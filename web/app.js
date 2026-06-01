/* ================================================
   HOTEL OPALA TECH — app.js
   Lógica principal da dashboard
   Supabase JS + Chart.js + Navegação
   ================================================ */

/* ── Estado global ── */
let supabase = null;
let chartStatus = null;
let chartHospedes = null;

/* ================================================
   INICIALIZAÇÃO
   ================================================ */

document.addEventListener('DOMContentLoaded', () => {
  initSupabase();
  initNavigation();
  initHamburger();
  initRefreshButton();
});

function initSupabase() {
  try {
    if (
      !window.SUPABASE_URL ||
      !window.SUPABASE_ANON_KEY ||
      window.SUPABASE_URL === 'SUA_URL_AQUI' ||
      window.SUPABASE_ANON_KEY === 'SUA_CHAVE_AQUI'
    ) {
      setStatus('error', 'Configure config.js');
      renderConfigWarning();
      return;
    }

    /* FIX 1: desestruturação correta do bundle UMD do Supabase JS v2 */
    const { createClient } = window.supabase;
    supabase = createClient(window.SUPABASE_URL, window.SUPABASE_ANON_KEY);

    setStatus('loading', 'Conectando...');
    loadDashboard();

  } catch (err) {
    setStatus('error', 'Erro ao conectar');
    console.error('[Hotel Opala] Erro Supabase:', err);
  }
}

/* ================================================
   STATUS DE CONEXÃO
   ================================================ */

function setStatus(type, message) {
  const dot  = document.getElementById('status-dot');
  const text = document.getElementById('status-text');
  if (!dot || !text) return;
  dot.className = 'status-dot ' + type;
  text.textContent = message;
}

/* ================================================
   LOAD DASHBOARD PRINCIPAL
   ================================================ */

async function loadDashboard() {
  try {
    await Promise.all([
      loadStats(),
      loadTabelaReservas(),
      loadChartStatus(),
      loadChartHospedes(),
    ]);
    setStatus('connected', 'Conectado');
  } catch (err) {
    setStatus('error', 'Erro ao carregar');
    console.error('[Hotel Opala] Erro loadDashboard:', err);
  }
}

/* ================================================
   CARDS DE ESTATÍSTICAS
   Tabelas: hospedes, quartos, reservas
   Colunas: valor_total
   ================================================ */

async function loadStats() {
  const [
    { count: totalHospedes },
    { count: totalQuartos  },
    { count: totalReservas },
    { data: receita        },
  ] = await Promise.all([
    supabase.from('hospedes').select('*', { count: 'exact', head: true }),
    supabase.from('quartos') .select('*', { count: 'exact', head: true }),
    supabase.from('reservas').select('*', { count: 'exact', head: true }),
    supabase.from('reservas').select('valor_total'),
  ]);

  document.getElementById('stat-hospedes').textContent = totalHospedes ?? '—';
  document.getElementById('badge-hospedes').textContent = totalHospedes ?? '—';

  document.getElementById('stat-quartos').textContent = totalQuartos ?? '—';
  document.getElementById('badge-quartos').textContent = totalQuartos ?? '—';

  document.getElementById('stat-reservas').textContent = totalReservas ?? '—';
  document.getElementById('badge-reservas').textContent = totalReservas ?? '—';

  const soma = (receita || []).reduce((acc, r) => acc + (parseFloat(r.valor_total) || 0), 0);
  document.getElementById('stat-receita').textContent = formatBRL(soma);
}

/* ================================================
   TABELA: RESERVAS (dashboard)
   Tabelas: reservas JOIN hospedes JOIN quartos
   Colunas usadas da base:
     reservas:  id, hospede_id, numero_quarto, data_entrada, data_saida, valor_total
     hospedes:  nome
     quartos:   numero, tipo
   FK: reservas.hospede_id   → hospedes.id
   FK: reservas.numero_quarto → quartos.numero
   ================================================ */

async function loadTabelaReservas() {
  const tbody = document.getElementById('tbody-reservas');
  if (!tbody) return;

  /*
   * FIX 2: O Supabase resolve FKs pelo nome da constraint gerada pelo PostgreSQL.
   * Quando a PK da tabela referenciada NÃO é "id" (caso de quartos.numero),
   * o Supabase pode não resolver automaticamente o join pelo nome da tabela.
   * Estratégia segura: buscar reservas + hospedes normalmente,
   * e incluir numero_quarto + tipo via join explícito com hint de FK.
   * Se o hint falhar, o fallback usa numero_quarto diretamente.
   */
  const { data, error } = await supabase
    .from('reservas')
    .select(`
      id,
      data_entrada,
      data_saida,
      valor_total,
      numero_quarto,
      hospede_id,
      hospedes ( nome ),
      quartos ( numero, tipo )
    `)
    .order('data_entrada', { ascending: false });

  if (error) {
    tbody.innerHTML = errorRow(7, error.message);
    return;
  }

  document.getElementById('rows-count').textContent =
    `${(data || []).length} registro${(data || []).length !== 1 ? 's' : ''}`;

  tbody.innerHTML = (data || []).map(r => `
    <tr>
      <td class="cell-id">#${r.id}</td>
      <td class="cell-name">${r.hospedes?.nome ?? '—'}</td>
      <td class="cell-num">${r.quartos?.numero ?? r.numero_quarto}</td>
      <td>${r.quartos?.tipo ?? '—'}</td>
      <td class="cell-date">${formatDate(r.data_entrada)}</td>
      <td class="cell-date">${formatDate(r.data_saida)}</td>
      <td class="cell-value">${formatBRL(r.valor_total)}</td>
    </tr>
  `).join('');
}

/* ================================================
   GRÁFICO 1: Quartos por Status
   Tabela: quartos
   Coluna: status — valores reais: 'Livre', 'Ocupado', 'Manutenção'
   ================================================ */

async function loadChartStatus() {
  const { data, error } = await supabase
    .from('quartos')
    .select('status');

  if (error || !data) return;

  const counts = {};
  data.forEach(q => {
    counts[q.status] = (counts[q.status] || 0) + 1;
  });

  const labels = Object.keys(counts);
  const values = Object.values(counts);

  /* Cores mapeadas pelos valores reais da coluna status */
  const colors = labels.map(l => {
    if (l === 'Livre')      return 'rgba(52,  211, 153, 0.85)';
    if (l === 'Ocupado')    return 'rgba(59,  130, 246, 0.85)';
    if (l === 'Manutenção') return 'rgba(251, 191,  36, 0.85)';
    return 'rgba(139, 92, 246, 0.85)';
  });

  const ctx = document.getElementById('chartStatus');
  if (!ctx) return;

  if (chartStatus) chartStatus.destroy();

  chartStatus = new Chart(ctx, {
    type: 'doughnut',
    data: {
      labels,
      datasets: [{
        data: values,
        backgroundColor: colors,
        borderColor: '#111118',
        borderWidth: 3,
        hoverOffset: 6,
      }],
    },
    options: {
      responsive: true,
      maintainAspectRatio: false,
      cutout: '68%',
      plugins: {
        legend: {
          position: 'bottom',
          labels: {
            color: '#8b8ba8',
            font: { family: 'Space Mono', size: 11 },
            boxWidth: 10,
            padding: 16,
          },
        },
        tooltip: tooltipStyle(),
      },
    },
  });
}

/* ================================================
   GRÁFICO 2: Reservas por Hóspede
   Tabelas: reservas JOIN hospedes
   Colunas: hospedes.nome
   ================================================ */

async function loadChartHospedes() {
  const { data, error } = await supabase
    .from('reservas')
    .select(`
      id,
      hospedes ( nome )
    `);

  if (error || !data) return;

  const counts = {};
  data.forEach(r => {
    const nome = r.hospedes?.nome ?? 'Desconhecido';
    const primeiro = nome.split(' ')[0];
    counts[primeiro] = (counts[primeiro] || 0) + 1;
  });

  const sorted = Object.entries(counts).sort((a, b) => b[1] - a[1]);
  const labels = sorted.map(([k]) => k);
  const values = sorted.map(([, v]) => v);

  const ctx = document.getElementById('chartHospedes');
  if (!ctx) return;

  if (chartHospedes) chartHospedes.destroy();

  chartHospedes = new Chart(ctx, {
    type: 'bar',
    data: {
      labels,
      datasets: [{
        label: 'Reservas',
        data: values,
        backgroundColor: 'rgba(139, 92, 246, 0.7)',
        borderColor: 'rgba(139, 92, 246, 1)',
        borderWidth: 1,
        borderRadius: 4,
        borderSkipped: false,
      }],
    },
    options: {
      responsive: true,
      maintainAspectRatio: false,
      plugins: {
        legend: { display: false },
        tooltip: tooltipStyle(),
      },
      scales: {
        x: {
          ticks: { color: '#8b8ba8', font: { family: 'Space Mono', size: 10 } },
          grid: { color: 'rgba(255,255,255,0.04)' },
          border: { color: 'rgba(255,255,255,0.06)' },
        },
        y: {
          ticks: { color: '#8b8ba8', font: { family: 'Space Mono', size: 10 }, stepSize: 1 },
          grid: { color: 'rgba(255,255,255,0.04)' },
          border: { color: 'rgba(255,255,255,0.06)' },
          beginAtZero: true,
        },
      },
    },
  });
}

/* ================================================
   SEÇÃO: HÓSPEDES
   Tabela: hospedes
   Colunas: id, nome, cpf, data_nascimento, telefone, email
   ================================================ */

async function loadSectionHospedes() {
  const tbody = document.getElementById('tbody-hospedes');
  if (!tbody || tbody.dataset.loaded) return;

  const { data, error } = await supabase
    .from('hospedes')
    .select('id, nome, cpf, data_nascimento, telefone, email')
    .order('nome');

  if (error) { tbody.innerHTML = errorRow(6, error.message); return; }

  document.getElementById('badge-hospedes').textContent = (data || []).length;

  tbody.innerHTML = (data || []).map(h => `
    <tr>
      <td class="cell-id">${h.id}</td>
      <td class="cell-name">${h.nome}</td>
      <td class="cell-num">${h.cpf}</td>
      <td class="cell-date">${formatDate(h.data_nascimento)}</td>
      <td>${h.telefone ?? '—'}</td>
      <td>${h.email ?? '—'}</td>
    </tr>
  `).join('');

  tbody.dataset.loaded = 'true';
}

/* ================================================
   SEÇÃO: QUARTOS
   Tabela: quartos
   Colunas: numero, tipo, valor_diaria, status
   PK: numero (não é id!)
   ================================================ */

async function loadSectionQuartos() {
  const tbody = document.getElementById('tbody-quartos');
  if (!tbody || tbody.dataset.loaded) return;

  const { data, error } = await supabase
    .from('quartos')
    .select('numero, tipo, valor_diaria, status')
    .order('numero');

  if (error) { tbody.innerHTML = errorRow(4, error.message); return; }

  document.getElementById('badge-quartos').textContent = (data || []).length;

  tbody.innerHTML = (data || []).map(q => `
    <tr>
      <td class="cell-num">${q.numero}</td>
      <td>${q.tipo}</td>
      <td class="cell-value">${formatBRL(q.valor_diaria)}</td>
      <td>${badgeStatus(q.status)}</td>
    </tr>
  `).join('');

  tbody.dataset.loaded = 'true';
}

/* ================================================
   SEÇÃO: RESERVAS (full)
   Tabelas: reservas JOIN hospedes JOIN quartos
   Colunas da base:
     reservas:  id, numero_quarto, data_entrada, data_saida, valor_total
     hospedes:  nome
     quartos:   numero, tipo
   ================================================ */

async function loadSectionReservas() {
  const tbody = document.getElementById('tbody-reservas-full');
  if (!tbody || tbody.dataset.loaded) return;

  const { data, error } = await supabase
    .from('reservas')
    .select(`
      id,
      data_entrada,
      data_saida,
      valor_total,
      numero_quarto,
      hospedes ( nome ),
      quartos ( numero, tipo )
    `)
    .order('data_entrada', { ascending: false });

  if (error) { tbody.innerHTML = errorRow(7, error.message); return; }

  document.getElementById('badge-reservas').textContent = (data || []).length;

  tbody.innerHTML = (data || []).map(r => `
    <tr>
      <td class="cell-id">#${r.id}</td>
      <td class="cell-name">${r.hospedes?.nome ?? '—'}</td>
      <td class="cell-num">${r.quartos?.numero ?? r.numero_quarto}</td>
      <td>${r.quartos?.tipo ?? '—'}</td>
      <td class="cell-date">${formatDate(r.data_entrada)}</td>
      <td class="cell-date">${formatDate(r.data_saida)}</td>
      <td class="cell-value">${formatBRL(r.valor_total)}</td>
    </tr>
  `).join('');

  tbody.dataset.loaded = 'true';
}

/* ================================================
   SEÇÃO: SERVIÇOS + CONSUMOS
   Tabela servicos:  id, descricao, valor
   Tabela consumos:  id, reserva_id, servico_id, quantidade
   FIX 3: consumos usa reserva_id (FK → reservas.id)
           e servico_id (FK → servicos.id)
   ================================================ */

async function loadSectionServicos() {
  const tbodyServ = document.getElementById('tbody-servicos');
  const tbodyCons = document.getElementById('tbody-consumos');
  if (!tbodyServ || tbodyServ.dataset.loaded) return;

  /* Serviços */
  const { data: servicos, error: errServ } = await supabase
    .from('servicos')
    .select('id, descricao, valor')
    .order('descricao');

  if (errServ) {
    tbodyServ.innerHTML = errorRow(3, errServ.message);
  } else {
    document.getElementById('badge-servicos').textContent = (servicos || []).length;
    tbodyServ.innerHTML = (servicos || []).map(s => `
      <tr>
        <td class="cell-id">${s.id}</td>
        <td class="cell-name">${s.descricao}</td>
        <td class="cell-value">${formatBRL(s.valor)}</td>
      </tr>
    `).join('');
  }

  /* Consumos
   * Colunas reais: id, reserva_id, servico_id, quantidade
   * FK: reserva_id  → reservas(id)
   * FK: servico_id  → servicos(id)
   */
  const { data: consumos, error: errCons } = await supabase
    .from('consumos')
    .select(`
      id,
      quantidade,
      reserva_id,
      servico_id,
      reservas ( id ),
      servicos ( descricao, valor )
    `)
    .order('id');

  if (errCons) {
    tbodyCons.innerHTML = errorRow(6, errCons.message);
  } else {
    tbodyCons.innerHTML = (consumos || []).map(c => {
      const subtotal = (c.quantidade || 0) * parseFloat(c.servicos?.valor || 0);
      return `
        <tr>
          <td class="cell-id">${c.id}</td>
          <td class="cell-num">#${c.reservas?.id ?? c.reserva_id}</td>
          <td class="cell-name">${c.servicos?.descricao ?? '—'}</td>
          <td class="cell-num">${c.quantidade}</td>
          <td class="cell-value">${formatBRL(c.servicos?.valor)}</td>
          <td class="cell-value">${formatBRL(subtotal)}</td>
        </tr>
      `;
    }).join('');
  }

  tbodyServ.dataset.loaded = 'true';
}

/* ================================================
   NAVEGAÇÃO POR SEÇÕES
   ================================================ */

function initNavigation() {
  document.querySelectorAll('.nav-item[data-section]').forEach(item => {
    item.addEventListener('click', e => {
      e.preventDefault();
      navigateTo(item.dataset.section);
      closeSidebar();
    });
  });
}

function navigateTo(section) {
  document.querySelectorAll('.nav-item').forEach(i => i.classList.remove('active'));
  document.querySelector(`.nav-item[data-section="${section}"]`)?.classList.add('active');

  const labels = {
    dashboard: 'Dashboard',
    hospedes:  'Hóspedes',
    quartos:   'Quartos',
    reservas:  'Reservas',
    servicos:  'Serviços',
  };
  const bc = document.getElementById('breadcrumb-section');
  if (bc) bc.textContent = labels[section] ?? section;

  document.querySelectorAll('.section').forEach(s => s.classList.remove('active'));
  document.getElementById(`section-${section}`)?.classList.add('active');

  if (!supabase) return;
  switch (section) {
    case 'hospedes': loadSectionHospedes(); break;
    case 'quartos':  loadSectionQuartos();  break;
    case 'reservas': loadSectionReservas(); break;
    case 'servicos': loadSectionServicos(); break;
  }
}

/* ================================================
   BOTÃO REFRESH
   ================================================ */

function initRefreshButton() {
  const btn = document.getElementById('btn-refresh');
  if (!btn) return;

  btn.addEventListener('click', async () => {
    if (!supabase) return;
    btn.classList.add('spinning');
    btn.disabled = true;

    ['tbody-hospedes','tbody-quartos','tbody-reservas-full','tbody-servicos','tbody-consumos']
      .forEach(id => {
        const el = document.getElementById(id);
        if (el) delete el.dataset.loaded;
      });

    await loadDashboard();
    btn.classList.remove('spinning');
    btn.disabled = false;
  });
}

/* ================================================
   HAMBURGER (mobile)
   ================================================ */

function initHamburger() {
  const btn     = document.getElementById('hamburger');
  const sidebar = document.getElementById('sidebar');
  if (!btn || !sidebar) return;

  const overlay = document.createElement('div');
  overlay.className = 'sidebar-overlay';
  document.body.appendChild(overlay);

  btn.addEventListener('click', () => {
    sidebar.classList.toggle('open');
    overlay.classList.toggle('visible');
  });

  overlay.addEventListener('click', closeSidebar);
}

function closeSidebar() {
  document.getElementById('sidebar')?.classList.remove('open');
  document.querySelector('.sidebar-overlay')?.classList.remove('visible');
}

/* ================================================
   AVISO DE CONFIGURAÇÃO
   ================================================ */

function renderConfigWarning() {
  const tbody = document.getElementById('tbody-reservas');
  if (tbody) {
    tbody.innerHTML = `
      <tr>
        <td colspan="7" style="padding:40px; text-align:center;">
          <div style="display:flex;flex-direction:column;align-items:center;gap:14px;">
            <div style="font-size:32px;">⚙️</div>
            <p style="color:#f0f0f8;font-weight:600;font-size:15px;">Configure o Supabase para carregar os dados</p>
            <p style="color:#8b8ba8;font-size:12px;max-width:380px;line-height:1.6;">
              Abra o arquivo <code style="color:#a78bfa;background:rgba(139,92,246,0.15);padding:2px 6px;border-radius:4px;">config.js</code>
              e preencha <code style="color:#a78bfa">SUPABASE_URL</code> e <code style="color:#a78bfa">SUPABASE_ANON_KEY</code>
              com os dados do seu projeto em
              <a href="https://supabase.com" target="_blank" style="color:#60a5fa;">supabase.com</a>.
            </p>
          </div>
        </td>
      </tr>`;
  }

  ['stat-hospedes','stat-quartos','stat-reservas','stat-receita'].forEach(id => {
    const el = document.getElementById(id);
    if (el) el.textContent = '—';
  });
}

/* ================================================
   HELPERS
   ================================================ */

function formatBRL(value) {
  const n = parseFloat(value);
  if (isNaN(n)) return '—';
  return n.toLocaleString('pt-BR', { style: 'currency', currency: 'BRL' });
}

function formatDate(str) {
  if (!str) return '—';
  const [y, m, d] = str.split('-');
  return `${d}/${m}/${y}`;
}

function badgeStatus(status) {
  const map = {
    'Livre':      'livre',
    'Ocupado':    'ocupado',
    'Manutenção': 'manutencao',
  };
  const cls = map[status] ?? 'livre';
  return `<span class="badge badge--${cls}">${status}</span>`;
}

function errorRow(cols, msg) {
  return `<tr class="error-row"><td colspan="${cols}">Erro ao carregar dados: ${msg}</td></tr>`;
}

function tooltipStyle() {
  return {
    backgroundColor: '#18181f',
    borderColor: 'rgba(255,255,255,0.08)',
    borderWidth: 1,
    titleColor: '#f0f0f8',
    bodyColor: '#8b8ba8',
    padding: 10,
    titleFont: { family: 'DM Sans', size: 12, weight: '600' },
    bodyFont: { family: 'Space Mono', size: 11 },
    cornerRadius: 6,
  };
}
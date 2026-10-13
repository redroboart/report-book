(() => {
'use strict';
const $ = (s, r = document) => r.querySelector(s);
const $$ = (s, r = document) => [...r.querySelectorAll(s)];
const esc = s => String(s ?? '').replace(/[&<>"']/g, c => ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[c]));
const sum = a => a.reduce((x, y) => x + y, 0);
const reduceMotion = matchMedia('(prefers-reduced-motion: reduce)').matches;

let D, cur = -1, busy = false;
const cand = id => D.candidates.find(c => c.id === id);
const chip = id => { const c = cand(id); return `<span class="chip ${c && c.isClient ? 'c' : 'f'}">${esc(id)}</span>`; };

/* ---------- chapter shell ---------- */
const head = (n, title, lead) => `
  <header class="ch-head">
    <div class="num" data-reveal>${String(n).padStart(2, '0')} / ${String(CH.length).padStart(2, '0')}</div>
    <h2 data-reveal>${esc(title)}</h2>
    ${lead ? `<p class="lead" data-reveal>${esc(lead)}</p>` : ''}
  </header>`;

/* ---------- sparkline ---------- */
function spark(vals, client) {
  const w = 120, h = 40, p = 4, min = Math.min(...vals), max = Math.max(...vals), span = max - min || 1;
  const pts = vals.map((v, i) => [p + i * (w - 2 * p) / (vals.length - 1), h - p - (v - min) / span * (h - 2 * p)]);
  const last = pts[pts.length - 1];
  return `<svg class="spark ${client ? 'client' : ''}" viewBox="0 0 ${w} ${h}" preserveAspectRatio="none" aria-hidden="true">
    <polyline pathLength="1" points="${pts.map(q => q.join(',')).join(' ')}"/><circle cx="${last[0]}" cy="${last[1]}" r="3"/></svg>`;
}

/* ---------- cover ---------- */
function constellation() {
  const cx = 260, cy = 260, R = 185, n = D.candidates.length;
  const nodes = D.candidates.map((c, i) => {
    const a = (-90 + i * 360 / n) * Math.PI / 180, r = 13 + c.intent * 1.4;
    return { c, i, r, x: cx + R * Math.cos(a), y: cy + R * Math.sin(a), lx: cx + (R + r + 16) * Math.cos(a), ly: cy + (R + r + 16) * Math.sin(a) };
  });
  return `<svg class="constellation" viewBox="0 0 520 520" role="img" aria-label="Candidates sized by vote intent">
    <g class="spin"><circle class="ring" cx="${cx}" cy="${cy}" r="${R}"/></g>
    <circle class="ring" cx="${cx}" cy="${cy}" r="120"/><circle class="ring" cx="${cx}" cy="${cy}" r="62"/>
    ${nodes.map(o => `<line class="cl-line" style="--i:${o.i}" pathLength="1" x1="${cx}" y1="${cy}" x2="${o.x}" y2="${o.y}"/>`).join('')}
    ${nodes.map(o => `<g><circle class="cl-node ${o.c.isClient ? 'client' : 'field'}" style="--i:${o.i}" cx="${o.x}" cy="${o.y}" r="${o.r}"/>
      <text class="cl-txt" x="${o.x}" y="${o.y}">${esc(o.c.id)}</text>
      <text class="cl-val" x="${o.lx}" y="${o.ly}">${o.c.intent}%</text></g>`).join('')}
    <text class="cl-core" x="${cx}" y="${cy + 6}">${n}</text><text class="cl-core-s" x="${cx}" y="${cy + 26}">candidates</text>
  </svg>`;
}
function cover() {
  const m = D.meta;
  return `<section class="cover"><div>
    <h1 data-reveal>${esc(m.title)}</h1>
    <p class="sub" data-reveal style="--i:1">${esc(m.subtitle)}</p>
    <div class="facts" data-reveal style="--i:2">
      <div><div class="big" data-count="${m.sampleSize}">0</div><div class="small">respondents</div></div>
      <div><div class="big" data-count="${m.marginOfError}" data-dec="1" data-prefix="±" data-suffix="%">0</div><div class="small">margin of error</div></div>
      <div><div class="big" data-count="${D.candidates.length}">0</div><div class="small">candidates, ${D.candidates.filter(c => c.isClient).length} from ${esc(m.client)}</div></div>
    </div>
    <button class="btn" data-go="1" data-reveal style="--i:3">Open the report</button>
    <p class="where" data-reveal style="--i:4">${esc(m.constituency)}. Fieldwork ${esc(m.fieldDates)}.</p>
    ${m.placeholder ? `<div class="banner" data-reveal style="--i:5">Sample data. Replace the contents of data/report.json with your own.</div>` : ''}
  </div>${constellation()}</section>`;
}

/* ---------- summary ---------- */
function summary() {
  const byI = [...D.candidates].sort((a, b) => b.intent - a.intent);
  const leader = byI[0];
  const clients = D.candidates.filter(c => c.isClient);
  const best = [...clients].sort((a, b) => b.intent - a.intent)[0];
  const rank = byI.indexOf(best) + 1, gap = leader.intent - best.intent;
  const cs = sum(clients.map(c => c.intent)), os = sum(D.candidates.filter(c => !c.isClient).map(c => c.intent));
  const segs = D.segments.map(s => [s.group + ': ' + s.label, s.values[best.id]]).sort((a, b) => b[1] - a[1]);
  const net = [...D.candidates].sort((a, b) => (b.favourable - b.unfavourable) - (a.favourable - a.unfavourable))[0];
  const lead1 = leader.isClient
    ? `${leader.name} leads the field.` : `${leader.name} (${leader.party}) leads the field.`;
  const cards = [
    [`${leader.intent}%`, 'Highest vote intent', `${lead1}`],
    [`#${rank}`, `${best.name}, best-placed from ${D.meta.client}`, gap ? `${gap} points behind the leader.` : 'Level with the leader.'],
    D.meta.sameContest
      ? [`${cs}%`, `Combined ${D.meta.client} intent`, `Against ${os}% for the other candidates and ${100 - cs - os}% undecided.`]
      : [`${100 - cs - os}%`, 'Undecided', 'Share of respondents who named no candidate.'],
    [`${net.favourable - net.unfavourable > 0 ? '+' : ''}${net.favourable - net.unfavourable}`, 'Best net favourability', `${net.name}: ${net.favourable}% favourable, ${net.unfavourable}% unfavourable.`]
  ];
  return head(2, 'What the numbers say', 'Four findings, then the analyst notes.') + `
    <div class="cards cols-4">${cards.map((c, i) => `<div class="card" data-reveal style="--i:${i}"><div class="big" data-count="${parseFloat(c[0].replace(/[^\d.-]/g, ''))}" data-prefix="${c[0][0] === '#' ? '#' : c[0][0] === '+' ? '+' : ''}" data-suffix="${c[0].endsWith('%') ? '%' : ''}">${esc(c[0])}</div>
      <p style="margin-top:12px;font-weight:600">${esc(c[1])}</p><p class="muted small" style="margin-top:4px">${esc(c[2])}</p></div>`).join('')}</div>
    <div class="cards cols-2" style="margin-top:16px">
      <div class="card" data-reveal style="--i:4"><h3>${esc(best.name)} by segment</h3>
        <p class="muted" style="margin-top:10px">Strongest with <b>${esc(segs[0][0])}</b> at ${segs[0][1]}%. Weakest with <b>${esc(segs[segs.length - 1][0])}</b> at ${segs[segs.length - 1][1]}%.</p></div>
      <div class="card" data-reveal style="--i:5"><h3>Analyst notes</h3>
        <ul class="plain-list">${(D.analystNotes || []).map(n => `<li>${esc(n)}</li>`).join('')}</ul></div>
    </div>
    <div class="card" style="margin-top:16px;border-left:4px solid var(--accent)" data-reveal style="--i:6">
      <div style="display:flex;align-items:center;gap:10px;margin-bottom:8px">
        <span class="chip c"><b>Strategic Notice</b></span>
        <h3 style="margin:0;font-size:18px">CM Face Popularity Decoupled from Halqa Party & Candidate Choices</h3>
      </div>
      <p class="muted" style="margin-top:6px;line-height:1.6">
        Statewide Chief Minister popularity is independent of constituency-level party and candidate preferences.
        Voters who view a state leadership face favorably do not automatically support their party in Roopnagar:
        <b>45.1% of Bhagwant Mann CM supporters</b> and <b>55.0% of Charanjeet Channi CM supporters</b> favor WPD or independent alternatives at the Halqa level, while AAP's local aspirant Ramkumar Mukari records only <b>32.3% recall</b> even among Mann's supporters.
      </p>
    </div>`;
}

/* ---------- method ---------- */
function method() {
  const m = D.method;
  return head(3, 'How the check was done', 'Quantitative survey first, then unstructured interviews with local reporters and opinion makers.') + `
    <div class="cards cols-2">
      ${[['Data collection', m.mode], ['Sampling', m.sampling], ['Weighting', m.weighting], ['Qualitative interviews', m.qualitative]]
        .map((x, i) => `<div class="card" data-reveal style="--i:${i}"><h3>${x[0]}</h3><p class="muted" style="margin-top:8px">${esc(x[1])}</p></div>`).join('')}
    </div>
    <div class="card" style="margin-top:16px;--i:4" data-reveal><h3>Read with care</h3>
      <ul class="plain-list">${m.limits.map(l => `<li>${esc(l)}</li>`).join('')}</ul></div>`;
}

/* ---------- roster ---------- */
function infobox(c) {
  const rows = [['Age', c.age], ['Gender', c.gender], ['Education', c.education], ['Profession', c.profession], ['Home', c.hometown], ['Public role', c.publicRole], ['Languages', c.languages], ['Social reach', c.socialReach]];
  return rows.map(r => `<dt>${r[0]}</dt><dd>${esc(r[1])}</dd>`).join('');
}
function roster() {
  const initials = c => c.id;
  return head(4, 'The seven candidates', 'Select a card for the full dossier, including interview mentions.') + `
    <div class="filters" data-reveal><button class="on" data-f="all">All seven</button><button data-f="client">${esc(D.meta.client)}</button><button data-f="field">Other parties</button></div>
    <div class="roster">${D.candidates.map((c, i) => `
      <button class="cand" data-id="${c.id}" data-kind="${c.isClient ? 'client' : 'field'}" data-reveal style="--i:${i}">
        <div class="card"><div class="avatar ${c.isClient ? 'client' : 'field'}">${esc(initials(c))}</div>
          <h3>${esc(c.name)}</h3><div class="party">${esc(c.party)}${c.firstTime ? ' &middot; first-time aspirant' : ''}</div>
          <dl><dt>Age</dt><dd>${c.age}</dd><dt>Profession</dt><dd>${esc(c.profession)}</dd><dt>Vote intent</dt><dd class="mono">${c.intent}%${c.intentRange ? ` <small class="muted" style="font-size:11px">(${c.intentRange[0]}%–${c.intentRange[1]}%)</small>` : ''}</dd></dl>
          <div class="open">Open dossier</div></div></button>`).join('')}</div>`;
}

/* ---------- results ---------- */
function results() {
  const byI = [...D.candidates].sort((a, b) => b.intent - a.intent);
  const cs = sum(D.candidates.filter(c => c.isClient).map(c => c.intent)), os = sum(D.candidates.filter(c => !c.isClient).map(c => c.intent)), und = 100 - cs - os;
  const row = (name, sub, v, cls, i) => `<div class="bar-row"><div class="bar-name">${esc(name)}<small>${esc(sub)}</small></div><div class="bar"><i class="${cls}" style="--w:${v / 30 * 100}%;--i:${i}"></i></div><div class="bar-val">${v}%</div></div>`;
  return head(5, 'Popularity at a glance', 'If the election were held tomorrow, whom would you vote for? Figures include Monte Carlo 95% confidence intervals.') + `
    <div class="card" data-reveal>${byI.map((c, i) => row(c.name, c.party, c.intent, c.isClient ? 'client' : '', i)).join('')}${row('Undecided', 'No candidate named', und, 'hatch', byI.length)}</div>
    ${D.meta.sameContest ? `<div class="card" style="margin-top:16px" data-reveal><h3>${esc(D.meta.client)} against the field</h3>
      <div class="stack"><span style="--w:${cs}%;background:var(--client)">${cs}%</span><span style="--w:${os}%;background:var(--field)">${os}%</span><span style="--w:${und}%;background:#9AA7BB">${und}%</span></div>
      <div class="legend"><span><i style="background:var(--client)"></i>${esc(D.meta.client)}</span><span><i style="background:var(--field)"></i>Other parties</span><span><i style="background:#9AA7BB"></i>Undecided</span></div></div>` : ''}
    <div class="card tbl" style="margin-top:16px" data-reveal><h3 style="margin-bottom:10px">Recall and favourability (Monte Carlo 95% Confidence Bounds)</h3>
      <table><thead><tr><th>Candidate</th><th class="n">Name recall (95% CI)</th><th class="n">Favourable</th><th class="n">Unfavourable</th><th class="n">Net</th></tr></thead><tbody>
      ${D.candidates.map(c => { const n = c.favourable - c.unfavourable; return `<tr><td>${chip(c.id)} ${esc(c.name)}</td><td class="n"><b>${c.recall}%</b>${c.recallRange ? ` <small class="muted mono">(${c.recallRange[0]}%–${c.recallRange[1]}%)</small>` : ''}</td><td class="n"><b>${c.favourable}%</b>${c.favourableRange ? ` <small class="muted mono">(${c.favourableRange[0]}%–${c.favourableRange[1]}%)</small>` : ''}</td><td class="n">${c.unfavourable}%</td><td class="n" style="color:${n >= 0 ? 'var(--good)' : 'var(--bad)'}">${n > 0 ? '+' : ''}${n}</td></tr>`; }).join('')}
      </tbody></table></div>
    <h3 style="margin:30px 0 12px" data-reveal>Movement across ${D.meta.pulseLabels.length} pulse checks</h3>
    <div class="cards cols-4">${D.candidates.map((c, i) => { const d = c.trend[c.trend.length - 1] - c.trend[0]; return `<div class="card" data-reveal style="--i:${i}">
      <div style="display:flex;justify-content:space-between"><b>${esc(c.id)}</b><span class="mono small ${d >= 0 ? 'tone-Positive' : 'tone-Critical'}">${d > 0 ? '+' : ''}${d} pts</span></div>${spark(c.trend, c.isClient)}</div>`; }).join('')}</div>`;
}

/* ---------- segments ---------- */
function segments() {
  const groups = [...new Set(D.segments.map(s => s.group))];
  let body = '';
  groups.forEach(g => {
    body += `<tr class="grp"><td colspan="${D.candidates.length + 3}">${esc(g)}</td></tr>`;
    D.segments.filter(s => s.group === g).forEach(s => {
      const vals = D.candidates.map(c => s.values[c.id]), top = Math.max(...vals), tot = sum(vals);
      body += `<tr><td>${esc(s.label)} <small class="muted" style="font-size:11px">(N=${s.n || '–'})</small></td>${D.candidates.map(c => { const v = s.values[c.id]; const a = Math.round(v / 30 * 85);
        const rng = s.ranges && s.ranges[c.id] ? ` title="${esc(c.name)}: ${s.ranges[c.id][0]}%–${s.ranges[c.id][1]}% (95% CI)"` : '';
        return `<td class="cell ${v === top ? 'lead' : ''}" style="background:color-mix(in srgb, ${c.isClient ? 'var(--client)' : 'var(--field)'} ${a}%, transparent)"${rng}>${v}</td>`; }).join('')}
        <td class="n">${100 - tot}</td></tr>`;
    });
  });
  return head(6, 'Who backs whom', 'Vote intent by age, gender and area. The outlined cell marks the leader in each row.') + `
    <div class="card tbl heat" data-reveal><table><thead><tr><th>Segment</th>${D.candidates.map(c => `<th class="n">${c.id}</th>`).join('')}<th class="n">Undecided</th></tr></thead><tbody>${body}</tbody></table>
    <div class="legend"><span><i style="background:var(--client)"></i>${esc(D.meta.client)} candidates</span><span><i style="background:var(--field)"></i>Other parties</span><span>Darker means higher intent. Figures are percentages.</span></div></div>`;
}

/* ---------- voices ---------- */
function voices() {
  return head(7, 'Voices from the ground', 'Unstructured interviews with local reporters and opinion makers, summarised as bullets.') + `
    <div class="filters" data-reveal><button class="on" data-v="all">Everyone</button><button data-v="Reporter">Reporters</button><button data-v="Opinion maker">Opinion makers</button></div>
    <div class="cards cols-2">${D.voices.map((v, i) => `
      <article class="card voice" data-type="${esc(v.type)}" data-reveal style="--i:${i}">
        <h3>${esc(v.name)}</h3>
        <div class="meta"><span class="chip">${esc(v.type)}</span><span class="small muted">${esc(v.outlet)}</span><span class="small tone-${esc(v.tone)}"><b>${esc(v.tone)}</b></span></div>
        <div>${v.mentions.map(chip).join(' ')}</div>
        <ul>${v.bullets.map(b => `<li>${esc(b)}</li>`).join('')}</ul></article>`).join('')}</div>`;
}

/* ---------- actions ---------- */
function actions() {
  return head(8, 'What to do next', 'Ordered by urgency.') + D.actions.map((a, i) => `
    <div class="card action" style="margin-bottom:14px;--i:${i}" data-reveal><div class="pri ${esc(a.priority)}">${esc(a.priority)}</div>
    <div><h3>${esc(a.title)}</h3><p class="muted" style="margin-top:6px">${esc(a.detail)}</p></div></div>`).join('');
}

/* ---------- appendix ---------- */
function appendix() {
  const terms = [
    ['Name recall', 'Share of respondents who recognized the candidate across the multi-select popularity check.'],
    ['Vote favorability', 'Share of respondents who chose the candidate among the Akali-background freshers.'],
    ['Monte Carlo 95% CI', 'Empirical 2.5th to 97.5th percentile bounds generated from 10,000 bootstrap simulations (N=1,797).'],
    ['Decoupled Vote', 'Phenomenon where state CM face popularity diverges from local Halqa candidate and party vote.']
  ];
  return head(9, 'Appendix', 'Definitions & Strategic Electoral Framework.') + `
    <div class="cards cols-2">
      <div class="card" data-reveal><h3>Methodology & Definitions</h3><ul class="plain-list">${terms.map(t => `<li><b>${t[0]}.</b> ${t[1]}</li>`).join('')}</ul></div>
      <div class="card" data-reveal style="--i:1"><h3>Strategic Framework: The Decoupled CM Factor</h3>
        <p class="muted" style="margin-top:8px;line-height:1.6">
          Electoral analysis in Punjab reveals a distinct bifurcation between state-level Chief Minister preference and local Halqa ballot choices:
        </p>
        <ul class="plain-list" style="margin-top:10px">
          <li><b>High-Level Narrative vs Local Trust:</b> State CM questions capture broad media visibility and party brand, whereas the constituency vote is decided by candidate accessibility, social standing, and community presence.</li>
          <li><b>Empirical Evidence:</b> Over <b>45.1% of Bhagwant Mann</b> and <b>55.0% of Charanjeet Channi</b> backers favor WPD or independent alternatives at the Halqa level.</li>
          <li><b>Campaign Implication:</b> High state CM ratings for a rival party do not preclude local victory; local grounding and personal goodwill can decisively counter state-level party headwinds.</li>
        </ul>
      </div>
    </div>`;
}

const CH = [
  { id: 'cover', label: 'Cover', render: cover }, { id: 'summary', label: 'Summary', render: summary },
  { id: 'method', label: 'Method', render: method }, { id: 'roster', label: 'Candidates', render: roster },
  { id: 'results', label: 'Popularity', render: results }, { id: 'segments', label: 'Segments', render: segments },
  { id: 'voices', label: 'Voices', render: voices }, { id: 'actions', label: 'Actions', render: actions },
  { id: 'appendix', label: 'Appendix', render: appendix }
];

/* ---------- count-up ---------- */
function countUp(root) {
  $$('[data-count]', root).forEach(el => {
    const to = parseFloat(el.dataset.count), dec = +el.dataset.dec || 0, pre = el.dataset.prefix || '', suf = el.dataset.suffix || '';
    const set = v => el.textContent = pre + (dec ? v.toFixed(dec) : Math.round(v).toLocaleString()) + suf;
    if (reduceMotion) return set(to);
    const t0 = performance.now() + 450, dur = 1100;
    const tick = t => { const k = Math.min(Math.max((t - t0) / dur, 0), 1); set(to * (1 - Math.pow(1 - k, 3))); if (k < 1) requestAnimationFrame(tick); };
    set(0); requestAnimationFrame(tick);
  });
}

/* ---------- navigation ---------- */
function swap(i) {
  const secs = $$('.chapter');
  if (cur >= 0) secs[cur].classList.remove('is-active');
  cur = i;
  const s = secs[i]; s.scrollTop = 0; s.classList.add('is-active');
  $$('.nav').forEach((b, k) => b.classList.toggle('on', k === i));
  $('#prev').disabled = i === 0; $('#next').disabled = i === CH.length - 1;
  history.replaceState(null, '', '#' + CH[i].id);
  countUp(s);
}
function go(i) {
  if (i === cur || busy || i < 0 || i >= CH.length) return;
  closeDrawer();
  if (reduceMotion || cur < 0) return swap(i);
  busy = true;
  const w = $('#wipe');
  $('#wipe-label').textContent = String(i + 1).padStart(2, '0') + '  ' + CH[i].label;
  w.className = 'wipe run' + (i < cur ? ' back' : '');
  setTimeout(() => swap(i), 340);
  setTimeout(() => { w.className = 'wipe'; busy = false; }, 820);
}

/* ---------- drawer ---------- */
function openDrawer(id) {
  const c = cand(id), d = $('#drawer');
  const vs = D.voices.filter(v => v.mentions.includes(id));
  d.innerHTML = `<button class="x" aria-label="Close">&times;</button><div class="dossier">
    <div class="avatar ${c.isClient ? 'client' : 'field'}">${esc(c.id)}</div>
    <span class="chip ${c.isClient ? 'c' : 'f'}">${esc(c.party)}</span>
    <h3>${esc(c.name)}</h3><p class="muted">${esc(c.tagline)}</p>
    <div class="stat-row">
      <div><div class="big">${c.intent}%</div><div class="small muted">vote intent</div>${c.intentRange ? `<div style="font-size:11px;color:var(--accent);margin-top:3px" class="mono">${c.intentRange[0]}%–${c.intentRange[1]}%</div>` : ''}</div>
      <div><div class="big">${c.recall}%</div><div class="small muted">name recall</div>${c.recallRange ? `<div style="font-size:11px;color:var(--accent);margin-top:3px" class="mono">${c.recallRange[0]}%–${c.recallRange[1]}%</div>` : ''}</div>
      <div><div class="big">${c.favourable - c.unfavourable > 0 ? '+' : ''}${c.favourable - c.unfavourable}</div><div class="small muted">net favourability</div>${c.favourableRange ? `<div style="font-size:11px;color:var(--good);margin-top:3px" class="mono">${c.favourableRange[0]}%–${c.favourableRange[1]}% fav</div>` : ''}</div>
    </div>
    <h4>Pulse checks</h4>${spark(c.trend, c.isClient)}
    <h4>Profile</h4><dl>${infobox(c)}</dl>
    <h4>In the interviews</h4>${vs.length ? vs.map(v => `<p class="small"><b>${esc(v.name)}</b> <span class="muted">(${esc(v.outlet)})</span></p><ul class="plain-list">${v.bullets.filter(b => b.includes(c.id)).map(b => `<li class="small">${esc(b)}</li>`).join('') || `<li class="small muted">Mentioned alongside others. See the Voices chapter.</li>`}</ul>`).join('') : '<p class="muted small">Not mentioned.</p>'}
  </div>`;
  d.classList.add('open'); $('#scrim').classList.add('open'); d.setAttribute('aria-hidden', 'false');
  $('.x', d).addEventListener('click', closeDrawer);
}
function closeDrawer() { $('#drawer').classList.remove('open'); $('#scrim').classList.remove('open'); $('#drawer').setAttribute('aria-hidden', 'true'); }

/* ---------- init ---------- */
function build() {
  $('#rail').innerHTML = `<div class="brand">${esc(D.meta.client)}</div><div class="brand-sub">Popularity check report-book</div>` +
    CH.map((c, i) => `<button class="nav" data-go="${i}"><b>${String(i + 1).padStart(2, '0')}</b>${c.label}</button>`).join('') +
    `<div class="grow"></div><div class="tools"><button id="print">Print</button></div><div class="hint">Use the left and right arrow keys to turn pages.</div>`;
  $('#stage').innerHTML = CH.map(c => `<section class="chapter" id="ch-${c.id}">${c.render()}</section>`).join('');
  $$('.chapter').forEach(sec => $$('[data-reveal]', sec).forEach((el, k) => { if (!el.style.getPropertyValue('--i')) el.style.setProperty('--i', Math.min(k, 8)); }));

  document.addEventListener('click', e => {
    const g = e.target.closest('[data-go]'); if (g) return go(+g.dataset.go);
    const c = e.target.closest('.cand'); if (c) return openDrawer(c.dataset.id);
    const f = e.target.closest('[data-f]'); if (f) {
      $$('[data-f]').forEach(b => b.classList.toggle('on', b === f));
      $$('.cand').forEach(x => x.classList.toggle('hide', f.dataset.f !== 'all' && x.dataset.kind !== f.dataset.f)); return;
    }
    const v = e.target.closest('[data-v]'); if (v) {
      $$('[data-v]').forEach(b => b.classList.toggle('on', b === v));
      $$('.voice').forEach(x => x.classList.toggle('hide', v.dataset.v !== 'all' && x.dataset.type !== v.dataset.v));
    }
  });
  $('#scrim').addEventListener('click', closeDrawer);
  $('#prev').addEventListener('click', () => go(cur - 1));
  $('#next').addEventListener('click', () => go(cur + 1));
  $('#print').addEventListener('click', () => window.print());
  document.addEventListener('keydown', e => {
    if (e.key === 'Escape') closeDrawer();
    else if (e.key === 'ArrowRight') go(cur + 1);
    else if (e.key === 'ArrowLeft') go(cur - 1);
  });
  const start = CH.findIndex(c => c.id === location.hash.slice(1));
  swap(start >= 0 ? start : 0);
}

  async function loadData() {
    const cfg = window.SUPABASE_CONFIG;
    if (cfg && cfg.url && cfg.anonKey) {
      try {
        const slug = cfg.reportSlug || 'latest';
        const endpoint = `${cfg.url.replace(/\/+$/, '')}/rest/v1/reports?slug=eq.${encodeURIComponent(slug)}&select=data`;
        const res = await fetch(endpoint, {
          headers: {
            'apikey': cfg.anonKey,
            'Authorization': `Bearer ${cfg.anonKey}`,
            'Cache-Control': 'no-cache'
          }
        });
        if (res.ok) {
          const rows = await res.json();
          if (rows && rows.length > 0 && rows[0].data) {
            D = rows[0].data;
            build();
            return;
          }
        }
        console.warn('Supabase query empty, falling back to data/report.json');
      } catch (e) {
        console.warn('Supabase fetch error, falling back to data/report.json:', e);
      }
    }

    fetch('data/report.json', { cache: 'no-store' })
      .then(r => { if (!r.ok) throw new Error(r.status); return r.json(); })
      .then(j => { D = j; build(); })
      .catch(err => {
        $('#stage').innerHTML = `<div class="error"><h2>Could not load report data</h2><p class="muted" style="margin-top:12px">Start the report-book with <b>python3 serve.py</b> or configure Supabase in js/config.js. (${esc(err.message)})</p></div>`;
      });
  }

  loadData();
})();

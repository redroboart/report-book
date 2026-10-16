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
  const w = 140, h = 44, p = 6, min = Math.min(...vals), max = Math.max(...vals), span = max - min || 1;
  const pts = vals.map((v, i) => [p + i * (w - 2 * p) / (vals.length - 1), h - p - (v - min) / span * (h - 2 * p)]);
  const last = pts[pts.length - 1];
  const strokeCol = client ? 'var(--client)' : 'var(--field)';
  const fillCol = client ? 'rgba(79, 70, 229, 0.12)' : 'rgba(71, 85, 105, 0.08)';
  return `<svg class="spark ${client ? 'client' : ''}" viewBox="0 0 ${w} ${h}" preserveAspectRatio="none" aria-hidden="true">
    <polygon points="${pts[0][0]},${h} ${pts.map(q => q.join(',')).join(' ')} ${last[0]},${h}" fill="${fillCol}"/>
    <polyline pathLength="1" points="${pts.map(q => q.join(',')).join(' ')}" stroke="${strokeCol}"/>
    <circle cx="${last[0]}" cy="${last[1]}" r="3.5" fill="${strokeCol}"/>
  </svg>`;
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
  const cs = sum(clients.map(c => c.intent)), os = sum(D.candidates.filter(c => !c.isClient).map(c => c.intent)), und = 100 - cs - os;
  const segs = D.segments.map(s => [s.group + ': ' + s.label, s.values[best.id]]).sort((a, b) => b[1] - a[1]);
  const net = [...D.candidates].sort((a, b) => (b.favourable - b.unfavourable) - (a.favourable - a.unfavourable))[0];
  const netScore = net.favourable - net.unfavourable;

  return head(2, 'Executive Summary: Electoral Standings', 'Pre-reflective intelligence snapshot across candidate recall, net sentiment, and demographic mobilization in Roopnagar.') + `
    <div class="bento-grid bento-summary">
      <!-- Bento Tile 1: Hero Client & Field Leader (Span 2) -->
      <div class="bento-card bento-span-2 bento-hero-client" data-reveal style="--i:0">
        <div style="display:flex;justify-content:space-between;align-items:flex-start">
          <span class="bento-pill-badge client">★ FIELD LEADER SPOTLIGHT</span>
          <span class="chip c">Rank #1 in Halqa</span>
        </div>
        <div style="display:flex;align-items:baseline;gap:8px;margin-top:10px">
          <div class="bento-stat-hero client" data-count="${leader.intent}" data-suffix="%">${leader.intent}%</div>
          ${leader.intentRange ? `<span class="mono muted" style="font-size:13px;font-weight:600">(${leader.intentRange[0]}%–${leader.intentRange[1]}% 95% CI)</span>` : ''}
        </div>
        <div class="bento-label" style="font-size:17px">${esc(leader.name)} <small style="font-weight:500;color:var(--ink2)">(${esc(leader.party)})</small></div>
        <div class="bento-sub">
          Leading the entire 7-aspirant field with a <b>+13.0 pt</b> Panthic lead over Gurinder Gogi (9%) and <b>+16.0 pts</b> over Dalvir Jatana (6%). Outpaces all rival party freshers in raw voter intent.
        </div>
        <div class="mini-bar" style="margin-top:16px;background:rgba(29,78,216,0.12)">
          <div class="mini-bar-fill client" style="width:${Math.min(leader.intent / 28 * 100, 100)}%"></div>
        </div>
      </div>

      <!-- Bento Tile 2: Best Net Sentiment (Span 1) -->
      <div class="bento-card bento-hero-good" data-reveal style="--i:1">
        <span class="bento-pill-badge good">HIGHEST TRUST RATING</span>
        <div class="bento-stat-hero good" data-count="${netScore}" data-prefix="${netScore > 0 ? '+' : ''}">+${netScore}</div>
        <div class="bento-label">Net Favourability</div>
        <div class="bento-sub">
          <b>${esc(net.name)}</b>: ${net.favourable}% favourable vs only ${net.unfavourable}% unfavourable. Minimal voter resistance.
        </div>
      </div>

      <!-- Bento Tile 3: Floating / Undecided Vote (Span 1) -->
      <div class="bento-card bento-hero-floating" data-reveal style="--i:2">
        <span class="bento-pill-badge slate">DECIDING BATTLEGROUND</span>
        <div class="bento-stat-hero" data-count="${und}" data-suffix="%">${und}%</div>
        <div class="bento-label">Undecided / Floating Pool</div>
        <div class="bento-sub">
          Uncommitted electorate segment. The primary conversion battleground for campaign booth teams.
        </div>
      </div>

      <!-- Bento Tile 4: Demographic Footprint (Span 2) -->
      <div class="bento-card bento-span-2" data-reveal style="--i:3">
        <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:6px">
          <span class="bento-pill-badge slate">DEMOGRAPHIC BASTIONS</span>
          <span class="small muted mono">${esc(best.name)}</span>
        </div>
        <div class="bento-label" style="font-size:16px;margin-top:2px">Strongest &amp; Weakest Demographic Segments</div>
        <div style="margin-top:12px;display:flex;flex-direction:column;gap:8px">
          <div>
            <div style="display:flex;justify-content:space-between;font-size:12.5px">
              <span><b>Peak Stronghold:</b> ${esc(segs[0][0])}</span>
              <span class="mono" style="color:var(--client-dark);font-weight:700">${segs[0][1]}%</span>
            </div>
            <div class="mini-bar" style="margin-top:4px"><div class="mini-bar-fill client" style="width:${segs[0][1] / 35 * 100}%"></div></div>
          </div>
          <div>
            <div style="display:flex;justify-content:space-between;font-size:12.5px">
              <span><b>Expansion Target:</b> ${esc(segs[segs.length - 1][0])}</span>
              <span class="mono" style="color:var(--ink3);font-weight:700">${segs[segs.length - 1][1]}%</span>
            </div>
            <div class="mini-bar" style="margin-top:4px"><div class="mini-bar-fill" style="width:${segs[segs.length - 1][1] / 35 * 100}%;background:#94A3B8"></div></div>
          </div>
        </div>
        <div class="bento-sub" style="margin-top:10px">
          High traction in rural and youth voter groups. Outreach expansion required in urban trade belts.
        </div>
      </div>

      <!-- Bento Tile 5: Panthic Consolidation vs Rivals (Span 2) -->
      <div class="bento-card bento-span-2" data-reveal style="--i:4">
        <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:6px">
          <span class="bento-pill-badge client">COALITION DYNAMICS</span>
          <span class="chip c">${esc(D.meta.client)}</span>
        </div>
        <div class="bento-label" style="font-size:16px;margin-top:2px">Combined ${esc(D.meta.client)} Pool (${cs}%)</div>
        <div class="stack" style="margin:12px 0 8px">
          <span style="--w:${cs}%;background:var(--client)">${cs}%</span>
          <span style="--w:${os}%;background:var(--field)">${os}%</span>
          <span style="--w:${und}%;background:#9AA7BB">${und}%</span>
        </div>
        <div class="legend" style="margin-top:6px">
          <span><i style="background:var(--client)"></i>${esc(D.meta.client)} (${cs}%)</span>
          <span><i style="background:var(--field)"></i>Other Parties (${os}%)</span>
          <span><i style="background:#9AA7BB"></i>Undecided (${und}%)</span>
        </div>
        <div class="bento-sub" style="margin-top:10px">
          Panthic/WPD-aligned intent commands <b>${cs}%</b> of the electorate, giving the movement strong collective plurality over divided mainstream rivals.
        </div>
      </div>

      <!-- Bento Tile 6: Field Analyst Synthesis (Span 2) -->
      <div class="bento-card bento-span-2" data-reveal style="--i:5">
        <span class="bento-pill-badge slate">GROUND INTELLIGENCE</span>
        <div class="bento-label" style="font-size:16px;margin-top:2px">Key Field Analyst Notes</div>
        <ul class="plain-list" style="margin-top:10px">
          ${(D.analystNotes || []).map(n => `<li style="margin-bottom:8px;font-size:13px;line-height:1.55">${esc(n)}</li>`).join('')}
        </ul>
      </div>

      <!-- Bento Tile 7: Decoupled CM Factor (Span 2) -->
      <div class="bento-card bento-span-2 bento-callout-strategic" data-reveal style="--i:6">
        <div style="display:flex;align-items:center;gap:8px;margin-bottom:6px">
          <span class="chip c"><b>Strategic Notice</b></span>
          <span class="bento-pill-badge client">DECOUPLED CM FACTOR</span>
        </div>
        <div class="bento-label" style="font-size:16px;margin-top:2px">Statewide CM Faces Diverge from Halqa Choice</div>
        <p class="muted" style="margin-top:8px;line-height:1.6;font-size:13px">
          Statewide Chief Minister popularity is independent of constituency-level ballot decisions.
          Voters who view a state leadership face favorably do not automatically support their party in Roopnagar:
          <b>45.1% of Bhagwant Mann CM supporters</b> and <b>55.0% of Charanjeet Channi CM supporters</b> favor WPD or independent alternatives at the Halqa level, while AAP's local aspirant Ramkumar Mukari records only <b>32.3% recall</b> even among Mann's supporters.
        </p>
      </div>
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
  const rows = [
    ['Age', c.age],
    ['Community', c.community],
    ['Base Area', c.areaOfOperations || c.hometown],
    ['Profession', c.profession],
    ['Key Enterprises', c.enterprises],
    ['Public Role', c.publicRole],
    ['Education', c.education],
    ['Languages', c.languages],
    ['Social Reach', c.socialReach]
  ].filter(r => r[1]);
  return rows.map(r => `<dt>${r[0]}</dt><dd>${esc(r[1])}</dd>`).join('');
}

function roster() {
  const initials = c => c.id;
  return head(4, 'The Seven Candidates', 'Select any candidate card to open their complete dossier, survey cross-tabs, and ground interviews.') + `
    <div class="filters" data-reveal><button class="on" data-f="all">All seven candidates</button><button data-f="client">${esc(D.meta.client)}</button><button data-f="field">Other parties</button></div>
    <div class="bento-roster">
      ${D.candidates.map((c, i) => {
        if (c.isClient && c.id === 'SB') {
          return `
            <button class="cand bento-cand-hero" data-id="${c.id}" data-kind="client" data-reveal style="--i:${i}">
              <div class="card">
                <div class="cand-top">
                  <div style="display:flex;align-items:center;gap:12px">
                    <div class="avatar client">${esc(initials(c))}</div>
                    <div>
                      <div style="display:flex;gap:6px;align-items:center;flex-wrap:wrap">
                        <span class="chip c">${esc(c.party)}</span>
                        <span class="bento-pill-badge client">★ FIELD LEADER</span>
                      </div>
                      <h3 style="margin:4px 0 0">${esc(c.name)}</h3>
                    </div>
                  </div>
                  <div style="text-align:right">
                    <div class="bento-stat-hero client" style="font-size:36px">${c.intent}%</div>
                    <div style="font-size:11px;color:var(--ink3);font-weight:600">VOTE INTENT ${c.intentRange ? `(${c.intentRange[0]}%–${c.intentRange[1]}%)` : ''}</div>
                  </div>
                </div>
                <p class="muted small" style="margin:0 0 10px;line-height:1.45">${esc(c.tagline)}</p>
                
                <div class="hero-stats">
                  <div class="hs-box">
                    <div class="hs-val client">${c.intent}%</div>
                    <div class="hs-lbl">Vote Intent</div>
                  </div>
                  <div class="hs-box">
                    <div class="hs-val">${c.recall}%</div>
                    <div class="hs-lbl">Name Recall</div>
                  </div>
                  <div class="hs-box">
                    <div class="hs-val good">+${c.favourable - c.unfavourable}</div>
                    <div class="hs-lbl">Net Sentiment (${c.favourable}% Fav)</div>
                  </div>
                </div>

                <div class="mini-bar" style="margin-top:14px">
                  <div class="mini-bar-fill client" style="width:${Math.min(c.intent / 25 * 100, 100)}%"></div>
                </div>

                <dl style="margin-top:12px">
                  <dt>Profession</dt><dd>${esc(c.profession)}</dd>
                  <dt>Hometown</dt><dd>${esc(c.hometown)}</dd>
                  <dt>Public Role</dt><dd>${esc(c.publicRole)}</dd>
                </dl>
                <div class="open" style="margin-top:12px"><b>View Complete Candidate Dossier &rarr;</b></div>
              </div>
            </button>`;
        }

        return `
          <button class="cand" data-id="${c.id}" data-kind="${c.isClient ? 'client' : 'field'}" data-reveal style="--i:${i}">
            <div class="card">
              <div class="cand-top">
                <div class="avatar ${c.isClient ? 'client' : 'field'}">${esc(initials(c))}</div>
                <span class="chip ${c.isClient ? 'c' : 'f'}">${esc(c.party)}</span>
              </div>
              <h3>${esc(c.name)}</h3>
              <p class="muted small" style="margin:4px 0 10px;line-height:1.4">${esc(c.tagline)}</p>
              <div class="mini-bar">
                <div class="mini-bar-fill ${c.isClient ? 'client' : ''}" style="width:${Math.min(c.intent / 25 * 100, 100)}%"></div>
              </div>
              <dl>
                <dt>Vote intent</dt><dd class="mono">${c.intent}%${c.intentRange ? ` <small class="muted" style="font-size:11px">(${c.intentRange[0]}%–${c.intentRange[1]}%)</small>` : ''}</dd>
                <dt>Name recall</dt><dd class="mono">${c.recall}%</dd>
                <dt>Profession</dt><dd>${esc(c.profession)}</dd>
              </dl>
              <div class="open">View Complete Dossier &rarr;</div>
            </div>
          </button>`;
      }).join('')}

      <!-- 9th Bento Tile: Comparative Field Assessment -->
      <div class="bento-intel-card cand-intel" data-reveal style="--i:7">
        <div>
          <span class="bento-pill-badge slate">ELECTORAL OUTLOOK</span>
          <h3 style="font-size:17px;margin:8px 0 6px">Field Assessment</h3>
          <p class="muted small" style="line-height:1.55">
            <b>Sukhwinder Singh Barwa</b> leads Panthic freshers by +13 pts over Gogi and +16 pts over Jatana.
            BJP's Lalpura commands high legacy name recall (73%) but faces partisan resistance.
          </p>
        </div>
        <div style="margin-top:14px;padding-top:12px;border-top:1px dashed var(--line)">
          <button class="btn small" data-go="4" style="width:100%;text-align:center;font-size:12px;padding:8px 12px">View Full Popularity Chart &rarr;</button>
        </div>
      </div>
    </div>`;
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
    body += `<tr class="grp"><td colspan="${D.candidates.length + 2}">${esc(g)} Breakdown</td></tr>`;
    D.segments.filter(s => s.group === g).forEach(s => {
      const vals = D.candidates.map(c => s.values[c.id]), top = Math.max(...vals);
      body += `<tr><td><b>${esc(s.label)}</b> <small class="muted mono" style="font-size:11px">(N=${(s.n || 0).toLocaleString()})</small></td>${D.candidates.map(c => {
        const v = s.values[c.id];
        const isBarwa = c.id === 'SB';
        const isOtherPanthak = c.isClient && !isBarwa;
        const a = Math.round(v / 70 * 85);
        const rng = s.ranges && s.ranges[c.id] ? ` title="${esc(c.name)}: ${s.ranges[c.id][0]}%–${s.ranges[c.id][1]}% (95% CI)"` : '';
        
        let bg = '';
        if (isBarwa) {
          bg = `background:color-mix(in srgb, var(--client) ${Math.max(20, a)}%, #EEF2FF);`;
        } else if (isOtherPanthak) {
          bg = `background:color-mix(in srgb, #6366F1 ${Math.round(a * 0.42)}%, transparent);`;
        } else {
          bg = `background:color-mix(in srgb, var(--field) ${Math.round(a * 0.52)}%, transparent);`;
        }
        
        const leadClass = v === top ? 'lead' : '';
        const barwaClass = isBarwa ? 'col-barwa' : '';
        return `<td class="cell ${barwaClass} ${leadClass}" style="${bg}"${rng}>${v}%</td>`;
      }).join('')}
      <td class="n mono muted" style="font-size:12px">${s.uncommitted !== undefined ? s.uncommitted + '%' : '–'}</td></tr>`;
    });
  });

  const tableHead = `<thead><tr><th>Demographic Segment</th>${D.candidates.map(c => {
    const isBarwa = c.id === 'SB';
    return `<th class="n ${isBarwa ? 'col-barwa-head' : ''}">${esc(c.id)}</th>`;
  }).join('')}<th class="n">Uncommitted</th></tr></thead>`;

  const panthakNotes = `
    <div class="panthak-section" data-reveal>
      <div class="panthak-header">
        <span class="panthak-pill">DEMOGRAPHIC PENETRATION DEEP-DIVE</span>
        <h3 style="margin:8px 0 4px">Caste &amp; Age Penetration: Four Panthak Candidates</h3>
        <p class="muted">Field interview crosstab synthesis evaluating generational mobilization, rural vs urban alignment, and community coalition consolidation across Roopnagar constituency.</p>
      </div>

      <!-- Metric Highlights Grid -->
      <div class="panthak-kpi-grid">
        <div class="panthak-kpi-card hero">
          <div class="panthak-kpi-val client">51.9%</div>
          <div class="panthak-kpi-title">Barwa Youth Average (&lt;35)</div>
          <div class="panthak-kpi-sub"><b>+24.1 pt lead</b> over Gogi (27.8%), +27.5 pts over Aulakh (24.4%), +32.7 pts over Jatana (19.2%). Only Panthak candidate with over 50% youth recall.</div>
        </div>

        <div class="panthak-kpi-card">
          <div class="panthak-kpi-val" style="color:#0284C7">63.3%</div>
          <div class="panthak-kpi-title">Saini Community Anchor</div>
          <div class="panthak-kpi-sub">Barwa's peak caste penetration (63.3%) outpaces AAP Mukari (39.0%) and rival Panthak contenders (Gogi 44.9%, Aulakh 44.9%).</div>
        </div>

        <div class="panthak-kpi-card">
          <div class="panthak-kpi-val" style="color:#D97706">56.0%</div>
          <div class="panthak-kpi-title">Senior Polarization (51+)</div>
          <div class="panthak-kpi-sub">Veteran Jarnail Aulakh peaks among 51+ elders (56.0%), but experiences a severe drop to 16.0% among first-time voters (18–25).</div>
        </div>

        <div class="panthak-kpi-card">
          <div class="panthak-kpi-val" style="color:#059669">53.4% / 52.5%</div>
          <div class="panthak-kpi-title">Cross-Faith Parity (Sikh / Hindu)</div>
          <div class="panthak-kpi-sub">Barwa achieves an exceptionally balanced cross-religious profile, overcoming traditional Panthak geographic and communal pigeonholing.</div>
        </div>
      </div>

      <!-- 4 Panthak Candidate Dossier Bento -->
      <div class="panthak-bento">
        <!-- 1. Sukhwinder Singh Barwa -->
        <div class="panthak-cand-card client-featured">
          <div class="cand-card-top">
            <div>
              <div class="cand-card-name">${chip('SB')} Sukhwinder Singh Barwa</div>
              <small class="muted">Waris Punjab De / Core Panthak &bull; Nurpur Bedi Belt &bull; Age: 30s</small>
            </div>
            <span class="chip c" style="font-weight:700">★ Panthak Leader</span>
          </div>

          <div class="age-bars-wrap">
            <div style="font-size:11px;font-weight:700;color:var(--ink);margin-bottom:2px">Age Cohort Penetration</div>
            <div class="age-bar-item">
              <span class="age-bar-label">18–25 yrs</span>
              <div class="age-bar-track"><div class="age-bar-fill" style="width:50%;background:var(--client)"></div></div>
              <span class="age-bar-val">50.0%</span>
            </div>
            <div class="age-bar-item">
              <span class="age-bar-label">26–35 yrs</span>
              <div class="age-bar-track"><div class="age-bar-fill" style="width:53.4%;background:var(--client)"></div></div>
              <span class="age-bar-val">53.4%</span>
            </div>
            <div class="age-bar-item">
              <span class="age-bar-label">36–50 yrs</span>
              <div class="age-bar-track"><div class="age-bar-fill" style="width:57.1%;background:var(--client)"></div></div>
              <span class="age-bar-val">57.1%</span>
            </div>
            <div class="age-bar-item">
              <span class="age-bar-label">51+ yrs</span>
              <div class="age-bar-track"><div class="age-bar-fill" style="width:50.3%;background:var(--client)"></div></div>
              <span class="age-bar-val">50.3%</span>
            </div>
          </div>

          <div>
            <div style="font-size:11px;font-weight:700;color:var(--ink);margin-bottom:6px">Caste &amp; Community Reach</div>
            <div class="caste-pills-wrap">
              <span class="caste-pill lead">Saini: <b>63.3%</b></span>
              <span class="caste-pill lead">Gujjar: <b>57.1%</b></span>
              <span class="caste-pill lead">General: <b>56.8%</b></span>
              <span class="caste-pill">OBC: <b>50.0%</b></span>
              <span class="caste-pill">SC: <b>47.4%</b></span>
              <span class="caste-pill">BC: <b>43.2%</b></span>
              <span class="caste-pill">Sikh: <b>53.4%</b></span>
              <span class="caste-pill">Hindu: <b>52.5%</b></span>
            </div>
          </div>

          <div class="cand-analysis-text">
            <b>Generational &amp; Caste Synthesis:</b> Barwa is the <b>only Panthak aspirant with an unbroken &ge;50% footprint across all age brackets</b>. His roots in <i>Sanjhi Sath</i> (Delhi Kisan Morcha), flood-relief operations, and local agribusiness (<i>Barwa Dairy &amp; Agri Solutions</i>) give him massive youth credibility (+26.6% over Gogi in 18–25). His strong standing among Sainis (63.3%) and Gujjars (57.1%) enables WPD to break out of single-caste limitations and contest both rural and semi-urban voter bases.
          </div>
        </div>

        <!-- 2. Gurinder Singh Gogi -->
        <div class="panthak-cand-card">
          <div class="cand-card-top">
            <div>
              <div class="cand-card-name">${chip('GG')} Gurinder Singh Gogi</div>
              <small class="muted">Akali Background &bull; Roopnagar Town &bull; Age: 50s</small>
            </div>
            <span class="chip" style="font-size:11px">Municipal Veteran</span>
          </div>

          <div class="age-bars-wrap">
            <div style="font-size:11px;font-weight:700;color:var(--ink);margin-bottom:2px">Age Cohort Penetration</div>
            <div class="age-bar-item">
              <span class="age-bar-label">18–25 yrs</span>
              <div class="age-bar-track"><div class="age-bar-fill" style="width:23.4%;background:#6366F1"></div></div>
              <span class="age-bar-val">23.4%</span>
            </div>
            <div class="age-bar-item">
              <span class="age-bar-label">26–35 yrs</span>
              <div class="age-bar-track"><div class="age-bar-fill" style="width:30.8%;background:#6366F1"></div></div>
              <span class="age-bar-val">30.8%</span>
            </div>
            <div class="age-bar-item">
              <span class="age-bar-label">36–50 yrs</span>
              <div class="age-bar-track"><div class="age-bar-fill" style="width:44.4%;background:#6366F1"></div></div>
              <span class="age-bar-val">44.4%</span>
            </div>
            <div class="age-bar-item">
              <span class="age-bar-label">51+ yrs</span>
              <div class="age-bar-track"><div class="age-bar-fill" style="width:43.4%;background:#6366F1"></div></div>
              <span class="age-bar-val">43.4%</span>
            </div>
          </div>

          <div>
            <div style="font-size:11px;font-weight:700;color:var(--ink);margin-bottom:6px">Caste &amp; Community Reach</div>
            <div class="caste-pills-wrap">
              <span class="caste-pill lead">Gujjar: <b>62.9%</b></span>
              <span class="caste-pill">Saini: <b>44.9%</b></span>
              <span class="caste-pill">Hindu: <b>41.7%</b></span>
              <span class="caste-pill">BC: <b>36.5%</b></span>
              <span class="caste-pill">OBC: <b>36.0%</b></span>
              <span class="caste-pill">General: <b>35.9%</b></span>
              <span class="caste-pill">Sikh: <b>32.9%</b></span>
              <span class="caste-pill">SC: <b>30.9%</b></span>
            </div>
          </div>

          <div class="cand-analysis-text">
            <b>Generational &amp; Caste Synthesis:</b> Gogi displays a <b>severe youth deficit</b> (under 25% in 18–25), trailing Barwa by 26.6 points among young voters who criticize his repeated party-hopping (SAD &harr; Congress &harr; AAP). His commercial and municipal ties give him high recall among urban Gujjars (62.9%) and Hindus (41.7%), but his numbers in core rural Panthak segments (32.9% Sikh, 35.9% General) lag far behind.
          </div>
        </div>

        <!-- 3. Dalvir Singh Jatana -->
        <div class="panthak-cand-card">
          <div class="cand-card-top">
            <div>
              <div class="cand-card-name">${chip('DJ')} Dalvir Singh Jatana</div>
              <small class="muted">Akali Background &bull; Jatana Village &bull; Age: 55</small>
            </div>
            <span class="chip" style="font-size:11px">Heritage Legacy</span>
          </div>

          <div class="age-bars-wrap">
            <div style="font-size:11px;font-weight:700;color:var(--ink);margin-bottom:2px">Age Cohort Penetration</div>
            <div class="age-bar-item">
              <span class="age-bar-label">18–25 yrs</span>
              <div class="age-bar-track"><div class="age-bar-fill" style="width:18.1%;background:#818CF8"></div></div>
              <span class="age-bar-val">18.1%</span>
            </div>
            <div class="age-bar-item">
              <span class="age-bar-label">26–35 yrs</span>
              <div class="age-bar-track"><div class="age-bar-fill" style="width:19.9%;background:#818CF8"></div></div>
              <span class="age-bar-val">19.9%</span>
            </div>
            <div class="age-bar-item">
              <span class="age-bar-label">36–50 yrs</span>
              <div class="age-bar-track"><div class="age-bar-fill" style="width:27.6%;background:#818CF8"></div></div>
              <span class="age-bar-val">27.6%</span>
            </div>
            <div class="age-bar-item">
              <span class="age-bar-label">51+ yrs</span>
              <div class="age-bar-track"><div class="age-bar-fill" style="width:23.9%;background:#818CF8"></div></div>
              <span class="age-bar-val">23.9%</span>
            </div>
          </div>

          <div>
            <div style="font-size:11px;font-weight:700;color:var(--ink);margin-bottom:6px">Caste &amp; Community Reach</div>
            <div class="caste-pills-wrap">
              <span class="caste-pill">Sikh: <b>27.0%</b></span>
              <span class="caste-pill">Saini: <b>26.5%</b></span>
              <span class="caste-pill">BC: <b>25.7%</b></span>
              <span class="caste-pill">General: <b>23.9%</b></span>
              <span class="caste-pill">Gujjar: <b>22.9%</b></span>
              <span class="caste-pill">SC: <b>22.4%</b></span>
              <span class="caste-pill">Hindu: <b>19.4%</b></span>
              <span class="caste-pill">OBC: <b>14.0%</b></span>
            </div>
          </div>

          <div class="cand-analysis-text">
            <b>Generational &amp; Caste Synthesis:</b> Despite carrying the powerful symbolic legacy of martyr Shaheed Bhai Balwinder Singh Jatana, Dalvir's support is <b>flat and capped under 28% across all age cohorts and caste groups</b>. Internal family succession disputes and lack of boots-on-the-ground campaign infrastructure restrict his outreach almost exclusively to a localized rural agrarian pocket.
          </div>
        </div>

        <!-- 4. Jarnail Singh Aulakh -->
        <div class="panthak-cand-card">
          <div class="cand-card-top">
            <div>
              <div class="cand-card-name">${chip('JA')} Jarnail Singh Aulakh</div>
              <small class="muted">Akali Veteran &bull; Aulakh Village &bull; Age: 52</small>
            </div>
            <span class="chip" style="font-size:11px">Taksali Veteran</span>
          </div>

          <div class="age-bars-wrap">
            <div style="font-size:11px;font-weight:700;color:var(--ink);margin-bottom:2px">Age Cohort Penetration</div>
            <div class="age-bar-item">
              <span class="age-bar-label">18–25 yrs</span>
              <div class="age-bar-track"><div class="age-bar-fill" style="width:16%;background:#A5B4FC"></div></div>
              <span class="age-bar-val">16.0%</span>
            </div>
            <div class="age-bar-item">
              <span class="age-bar-label">26–35 yrs</span>
              <div class="age-bar-track"><div class="age-bar-fill" style="width:30.1%;background:#A5B4FC"></div></div>
              <span class="age-bar-val">30.1%</span>
            </div>
            <div class="age-bar-item">
              <span class="age-bar-label">36–50 yrs</span>
              <div class="age-bar-track"><div class="age-bar-fill" style="width:48.5%;background:#6366F1"></div></div>
              <span class="age-bar-val">48.5%</span>
            </div>
            <div class="age-bar-item">
              <span class="age-bar-label">51+ yrs</span>
              <div class="age-bar-track"><div class="age-bar-fill" style="width:56%;background:var(--client)"></div></div>
              <span class="age-bar-val">56.0%</span>
            </div>
          </div>

          <div>
            <div style="font-size:11px;font-weight:700;color:var(--ink);margin-bottom:6px">Caste &amp; Community Reach</div>
            <div class="caste-pills-wrap">
              <span class="caste-pill lead">BC: <b>54.1%</b></span>
              <span class="caste-pill">Gujjar: <b>45.7%</b></span>
              <span class="caste-pill">Hindu: <b>45.7%</b></span>
              <span class="caste-pill">Saini: <b>44.9%</b></span>
              <span class="caste-pill">SC: <b>40.1%</b></span>
              <span class="caste-pill">OBC: <b>38.0%</b></span>
              <span class="caste-pill">Sikh: <b>36.2%</b></span>
              <span class="caste-pill">General: <b>35.0%</b></span>
            </div>
          </div>

          <div class="cand-analysis-text">
            <b>Generational &amp; Caste Synthesis:</b> Aulakh illustrates <b>extreme generational polarization</b>. While leading all Panthak aspirants among voters aged 51+ (56.0%) and Backward Classes (54.1%) due to long-standing community work, his penetration plunges to 16.0% in the 18–25 cohort. He lacks contemporary appeal and digital campaign apparatus to attract Punjab's younger demographic.
          </div>
        </div>
      </div>

      <!-- Strategic Takeaway Box -->
      <div class="panthak-strategic-card card" style="border-left:4px solid var(--client);background:linear-gradient(135deg, #FFFFFF 0%, #EEF2FF 100%)">
        <h4 style="margin:0 0 6px;color:var(--ink)">Strategic Electoral Implications for Waris Punjab De</h4>
        <p class="muted" style="line-height:1.6;font-size:13.5px">
          The survey data conclusively confirms that <b>Sukhwinder Singh Barwa is the only Panthak face who solves the dual strategic challenges of youth consolidation and caste diversification</b>. With under-35 voters accounting for over 40% of Roopnagar's active voting electorate, Barwa's +24.1 point youth advantage over Gogi and +27.5 point advantage over Aulakh makes him the essential vanguard to prevent vote splitting. Furthermore, his 63.3% Saini and 57.1% Gujjar recall neutralize third-front challengers (Kamal Chauhan and Gaurav Rana) and position WPD to contest the BJP's Lalpura and AAP's Mukari directly in both agrarian and town corridors.
        </p>
      </div>
    </div>`;

  return head(6, 'Demographic & Caste Segments', 'Candidate favorability and recall across age cohorts, religious groups, and caste communities in Roopnagar. The outlined cell marks the leader in each row.') + `
    <div class="card tbl heat" data-reveal>
      <table>${tableHead}<tbody>${body}</tbody></table>
      <div class="legend">
        <span><i style="background:var(--client);border:1px solid var(--accent-border)"></i><b>Sukhwinder S. Barwa</b> [Highlighted Column]</span>
        <span><i style="background:color-mix(in srgb, #6366F1 45%, transparent)"></i>Other Panthak Aspirants (GG, DJ, JA)</span>
        <span><i style="background:color-mix(in srgb, var(--field) 55%, transparent)"></i>Rival Parties (AL, AS, RM)</span>
        <span>All figures represent candidate favorability &amp; recall percentages within demographic groups.</span>
      </div>
    </div>
    ${panthakNotes}`;
}

/* ---------- field heatmap ---------- */
let leafletMap = null, heatLayer = null, markersLayer = null;

function geoMap() {
  const g = D.geo;
  if (!g) return head(7, 'Geographic Survey Coverage', 'No geographic coordinates recorded.') + '<div class="card"><p class="muted">GPS location data unavailable.</p></div>';

  const zoneCards = (g.zones || []).map(z => `
    <div class="geo-zone-card">
      <div class="zone-title">${esc(z.name)}</div>
      <div class="zone-n">${z.n} <small style="font-size:12px;font-weight:500;color:var(--ink3)">interviews (${z.pctOfTotal}%)</small></div>
      <div class="zone-bars">
        <div class="zone-bar-row">
          <span><b>Sukhwinder S. Barwa</b></span>
          <span class="mono">${z.shares.SSB}%</span>
        </div>
        <div class="zone-bar-fill"><div style="width:${z.shares.SSB / 35 * 100}%;background:var(--client)"></div></div>
        
        <div class="zone-bar-row" style="color:var(--ink3);margin-top:2px">
          <span>Gogi ${z.shares.GSG}% &bull; Jatana ${z.shares.DJ}% &bull; Aulakh ${z.shares.JSA}%</span>
          <span class="mono">${z.shares.Undecided}% und.</span>
        </div>
      </div>
    </div>`).join('');

  return head(7, 'Geographic Survey Coverage', `${(g.totalSample || 1437).toLocaleString()} GPS-verified field interview locations across Roopnagar assembly constituency and key corridors.`) + `
    <div class="geo-layout" data-reveal>
      <div class="geo-stats-grid">
        ${zoneCards}
      </div>

      <div class="geo-controls-bar">
        <div class="geo-btn-group" id="geo-filters">
          <button class="geo-btn active" data-geo-mode="all">All Survey Coverage (Density)</button>
          <button class="geo-btn" data-geo-mode="SSB">Sukhwinder S. Barwa Hotspots</button>
          <button class="geo-btn" data-geo-mode="GSG">Gurinder Gogi Hotspots</button>
          <button class="geo-btn" data-geo-mode="DJ">Dalvir Jatana Hotspots</button>
          <button class="geo-btn" data-geo-mode="JSA">Jarnail Aulakh Hotspots</button>
          <button class="geo-btn" data-geo-mode="markers">Cluster Markers &amp; Popups</button>
        </div>
        <div class="geo-legend">
          <span>Low Density</span>
          <div class="geo-legend-gradient"></div>
          <span>High Density</span>
        </div>
      </div>

      <div class="geo-map-frame">
        <div id="geo-map"></div>
      </div>

      <div class="card" style="border-left:4px solid var(--accent)">
        <h4 style="margin:0 0 6px">Fieldwork Spatial Observations</h4>
        <p class="muted" style="line-height:1.6;font-size:13.5px">
          Field coverage reflects high sampling depth in the northern Nurpur Bedi corridor (36.3% of geo sample, N=522) and central Ghanauli rural belt (23.4%, N=336), alongside urban Ropar and the southern border (19.2%, N=276), and the Kiratpur Nangal corridor (21.1%, N=303).
          <b>Sukhwinder Singh Barwa maintains a consistent lead across all 4 quadrants</b>, recording his highest relative favorability in South Ropar (28.3%) and North-Central Nurpur Bedi (25.9%).
        </p>
      </div>
    </div>`;
}

function initGeoMap() {
  const g = D.geo;
  const container = $('#geo-map');
  if (!container || !g) return;
  if (!window.L) {
    setTimeout(initGeoMap, 200);
    return;
  }
  if (leafletMap) {
    leafletMap.invalidateSize();
    return;
  }

  try {
    leafletMap = L.map('geo-map', {
      center: g.center || [31.1154, 76.4925],
      zoom: g.zoom || 11,
      minZoom: 9,
      maxZoom: 17,
      scrollWheelZoom: false
    });

    const osm = L.tileLayer('https://tile.openstreetmap.org/{z}/{x}/{y}.png', {
      attribution: '&copy; <a href="https://www.openstreetmap.org/copyright" target="_blank">OpenStreetMap</a> contributors',
      maxZoom: 19
    }).addTo(leafletMap);

    const esriGray = L.tileLayer('https://server.arcgisonline.com/ArcGIS/rest/services/Canvas/World_Light_Gray_Base/MapServer/tile/{z}/{y}/{x}', {
      attribution: 'Tiles &copy; Esri &mdash; Esri, DeLorme, NAVTEQ',
      maxZoom: 16
    });

    const satellite = L.tileLayer('https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}', {
      attribution: 'Tiles &copy; Esri &mdash; Source: Esri, i-cubed, USDA, USGS, AEX, GeoEye, Getmapping, Aerogrid, IGN, IGP, UPR-EGP',
      maxZoom: 18
    });

    L.control.layers({
      'Street Map (OSM)': osm,
      'Muted Gray': esriGray,
      'Satellite': satellite
    }, null, { position: 'topright' }).addTo(leafletMap);

    if (g.bounds) {
      leafletMap.fitBounds(g.bounds, { padding: [25, 25] });
    }

    updateGeoLayer('all');
  } catch (err) {
    console.error('Error initializing Leaflet map:', err);
  }
}

function updateGeoLayer(mode) {
  if (!leafletMap || !window.L || !D.geo) return;
  const g = D.geo;

  if (heatLayer) {
    leafletMap.removeLayer(heatLayer);
    heatLayer = null;
  }
  if (markersLayer) {
    leafletMap.removeLayer(markersLayer);
    markersLayer = null;
  }

  if (mode === 'markers') {
    markersLayer = L.layerGroup();
    const candColors = {
      'SSB': '#4F46E5', // Electric Indigo (Client / Field Leader)
      'GSG': '#0D9488', // Emerald Teal (AAP)
      'DJ': '#2563EB',  // Cobalt Blue (INC)
      'JSA': '#D97706', // Amber Gold (SAD)
      'Undecided': '#94A3B8' // Slate Neutral
    };
    const candNames = {
      'SSB': 'Sukhwinder S. Barwa',
      'GSG': 'Gurinder Gogi',
      'DJ': 'Dalvir Jatana',
      'JSA': 'Jarnail Aulakh',
      'Undecided': 'Undecided'
    };

    g.clusters.forEach(cl => {
      const col = cl.topCand === 'SSB' ? '#4F46E5' : (candColors[cl.topCand] || '#475569');
      const r = Math.min(5 + (cl.count / 3) * 1.5, 18);

      const m = L.circleMarker([cl.lat, cl.lng], {
        radius: r,
        fillColor: col,
        color: '#FFFFFF',
        weight: 1.5,
        opacity: 0.9,
        fillOpacity: 0.75
      });

      const candBreakdown = Object.entries(cl.cands).map(([c, cnt]) => `
        <div class="geo-popup-row"><span>${candNames[c] || c}</span><b>${cnt} (${Math.round(cnt / cl.count * 100)}%)</b></div>`).join('');

      m.bindPopup(`
        <div class="geo-popup-title">${esc(cl.zone)}</div>
        <div class="geo-popup-badge">${cl.count} respondent${cl.count > 1 ? 's' : ''}</div>
        <div style="margin-top:6px">
          <div style="font-size:11px;font-weight:700;color:var(--ink2);margin-bottom:3px">CANDIDATE FAVORABILITY:</div>
          ${candBreakdown}
        </div>
        <div style="margin-top:8px;padding-top:6px;border-top:1px solid var(--line);font-size:11.5px">
          <b>Dominant CM Face:</b> ${esc(cl.topCM)}
        </div>
      `);
      markersLayer.addLayer(m);
    });
    markersLayer.addTo(leafletMap);
    return;
  }

  let filteredPoints = g.points;
  let gradient = {
    0.2: '#C7D2FE',
    0.4: '#818CF8',
    0.6: '#10B981',
    0.8: '#4F46E5',
    1.0: '#312E81'
  };

  if (mode !== 'all') {
    filteredPoints = g.points.filter(p => p.cand === mode);
    if (mode === 'SSB') {
      gradient = {
        0.2: '#EEF2FF',
        0.4: '#A5B4FC',
        0.7: '#6366F1',
        1.0: '#4338CA'
      };
    } else {
      gradient = {
        0.2: '#BAE6FD',
        0.4: '#38BDF8',
        0.7: '#0284C7',
        1.0: '#0369A1'
      };
    }
  }

  const heatPoints = filteredPoints.map(p => [p.lat, p.lng, 0.8]);

  if (L.heatLayer) {
    heatLayer = L.heatLayer(heatPoints, {
      radius: mode === 'all' ? 24 : 32,
      blur: 18,
      maxZoom: 15,
      gradient: gradient
    }).addTo(leafletMap);
  }
}

/* ---------- voices ---------- */
function voices() {
  return head(8, 'Voices from the ground', 'In-depth perspectives from political analysts, youth organizers, commentators, and field reporters.') + `
    <div class="filters" data-reveal>
      <button class="on" data-v="all">All Perspectives</button>
      <button data-v="Political Analyst">Political Analysts</button>
      <button data-v="Youth Activist">Youth &amp; Students</button>
      <button data-v="Political Commentator">Political Commentators</button>
      <button data-v="Field Reporter">Field Reporters</button>
    </div>
    <div class="cards cols-2">${D.voices.map((v, i) => `
      <article class="card voice" data-type="${esc(v.type)}" data-reveal style="--i:${i}">
        <h3>${esc(v.name)}</h3>
        <div class="meta"><span class="chip">${esc(v.type)}</span>${v.context ? `<span class="small muted">${esc(v.context)}</span>` : ''}<span class="small tone-${esc(v.tone)}"><b>${esc(v.tone)}</b></span></div>
        <div>${v.mentions.map(chip).join(' ')}</div>
        <ul>${v.bullets.map(b => `<li>${esc(b)}</li>`).join('')}</ul></article>`).join('')}</div>`;
}

/* ---------- actions ---------- */
function actions() {
  return head(9, 'What to do next', 'Ordered by urgency.') + D.actions.map((a, i) => `
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
  return head(10, 'Appendix', 'Definitions & Strategic Electoral Framework.') + `
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
  { id: 'geo', label: 'Field Heatmap', render: geoMap },
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
  if (CH[i].id === 'geo') {
    setTimeout(initGeoMap, 60);
  }
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
  setTimeout(() => {
    w.className = 'wipe';
    busy = false;
    if (CH[cur] && CH[cur].id === 'geo' && leafletMap) {
      leafletMap.invalidateSize();
    }
  }, 820);
}

/* ---------- drawer ---------- */
function openDrawer(id) {
  const c = cand(id), d = $('#drawer');
  const vs = D.voices.filter(v => v.mentions.includes(id));
  d.innerHTML = `<button class="x" aria-label="Close">&times;</button><div class="dossier">
    <div style="display:flex;align-items:center;gap:14px;margin-bottom:14px">
      <div class="avatar ${c.isClient ? 'client' : 'field'}">${esc(c.id)}</div>
      <div>
        <span class="chip ${c.isClient ? 'c' : 'f'}">${esc(c.party)}</span>
        <h3 style="margin:4px 0 0">${esc(c.name)}</h3>
      </div>
    </div>
    <p class="muted" style="line-height:1.55">${esc(c.tagline)}</p>
    <div class="stat-row">
      <div><div class="big">${c.intent}%</div><div class="small muted">vote intent</div>${c.intentRange ? `<div style="font-size:11px;color:var(--accent);margin-top:3px" class="mono">${c.intentRange[0]}%–${c.intentRange[1]}%</div>` : ''}</div>
      <div><div class="big">${c.recall}%</div><div class="small muted">name recall</div>${c.recallRange ? `<div style="font-size:11px;color:var(--accent);margin-top:3px" class="mono">${c.recallRange[0]}%–${c.recallRange[1]}%</div>` : ''}</div>
      <div><div class="big">${c.favourable - c.unfavourable > 0 ? '+' : ''}${c.favourable - c.unfavourable}</div><div class="small muted">net favourability</div>${c.favourableRange ? `<div style="font-size:11px;color:var(--good);margin-top:3px" class="mono">${c.favourableRange[0]}%–${c.favourableRange[1]}% fav</div>` : ''}</div>
    </div>
    <h4>Pulse Checks &amp; Trend</h4>${spark(c.trend, c.isClient)}
    <h4>Candidate Profile &amp; Background</h4>
    ${c.bio ? `<p style="line-height:1.6;font-size:13px;color:var(--ink2);margin-bottom:12px;background:var(--paper);padding:12px 14px;border:1px solid var(--line);border-radius:var(--radius-sm)">${esc(c.bio)}</p>` : ''}
    <dl>${infobox(c)}</dl>
    ${c.panthakRecord ? `
      <h4>Panthak &amp; Civil Rights Record</h4>
      <div class="card" style="padding:14px 16px;background:var(--paper);border-left:4px solid var(--client);margin-bottom:14px">
        <p class="small" style="line-height:1.6;color:var(--ink2)">${esc(c.panthakRecord)}</p>
      </div>` : ''}
    ${c.pros || c.cons ? `
      <h4>Strategic Assessment</h4>
      <div style="display:grid;grid-template-columns:1fr;gap:10px;margin-bottom:14px">
        ${c.pros ? `<div class="card" style="padding:12px 14px;background:#F0FDF4;border:1px solid #BBF7D0"><b style="color:var(--good);font-size:11.5px;text-transform:uppercase;letter-spacing:0.04em">Key Strengths (Pros):</b><p class="small" style="margin-top:4px;color:var(--ink);line-height:1.55">${esc(c.pros)}</p></div>` : ''}
        ${c.cons ? `<div class="card" style="padding:12px 14px;background:#FFFBEB;border:1px solid #FDE68A"><b style="color:var(--warn);font-size:11.5px;text-transform:uppercase;letter-spacing:0.04em">Strategic Challenges (Cons):</b><p class="small" style="margin-top:4px;color:var(--ink);line-height:1.55">${esc(c.cons)}</p></div>` : ''}
      </div>` : ''}
    <h4>In The Field Interviews</h4>${vs.length ? vs.map(v => `<div class="card" style="margin-bottom:12px;padding:14px 16px;background:var(--paper)"><div style="display:flex;align-items:center;justify-content:space-between;margin-bottom:6px"><p class="small"><b>${esc(v.name)}</b>${v.context ? ` <span class="muted">&bull; ${esc(v.context)}</span>` : ''}</p><span class="chip small">${esc(v.type)}</span></div><ul class="plain-list">${v.bullets.map(b => `<li class="small" style="line-height:1.55;margin-bottom:4px">${esc(b)}</li>`).join('')}</ul></div>`).join('') : '<p class="muted small">No specific individual quotes recorded.</p>'}
  </div>`;
  d.classList.add('open'); $('#scrim').classList.add('open'); d.setAttribute('aria-hidden', 'false');
  $('.x', d).addEventListener('click', closeDrawer);
}
function closeDrawer() { $('#drawer').classList.remove('open'); $('#scrim').classList.remove('open'); $('#drawer').setAttribute('aria-hidden', 'true'); }

/* ---------- init ---------- */
function build() {
  $('#rail').innerHTML = `
    <div class="brand-header">
      <div class="brand-badge"><span class="pulse-dot"></span>CCPA INTELLIGENCE</div>
      <div class="brand">${esc(D.meta.constituency || 'Roopnagar')}</div>
      <div class="brand-sub">${esc(D.meta.title || 'Assembly Poll 2026')}</div>
    </div>
    <div class="nav-group">
      ${CH.map((c, i) => `<button class="nav" data-go="${i}"><span class="nav-num">${String(i + 1).padStart(2, '0')}</span><span>${c.label}</span></button>`).join('')}
    </div>
    <div class="grow"></div>
    <div class="rail-footer">
      <div class="tools"><button id="print"><svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="margin-right:6px;vertical-align:-2px"><path d="M6 9V2h12v7M6 18H4a2 2 0 0 1-2-2v-5a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2v5a2 2 0 0 1-2 2h-2"/><path d="M6 14h12v8H6z"/></svg>Export PDF Report</button></div>
      <div class="hint">Use <kbd>&larr;</kbd> <kbd>&rarr;</kbd> to navigate</div>
    </div>`;
  $('#stage').innerHTML = CH.map(c => `<section class="chapter" id="ch-${c.id}">${c.render()}</section>`).join('');
  $$('.chapter').forEach(sec => $$('[data-reveal]', sec).forEach((el, k) => { if (!el.style.getPropertyValue('--i')) el.style.setProperty('--i', Math.min(k, 8)); }));

  document.addEventListener('click', e => {
    const g = e.target.closest('[data-go]'); if (g) return go(+g.dataset.go);
    const c = e.target.closest('.cand'); if (c) return openDrawer(c.dataset.id);
    const f = e.target.closest('[data-f]'); if (f) {
      $$('[data-f]').forEach(b => b.classList.toggle('on', b === f));
      $$('.cand').forEach(x => x.classList.toggle('hide', f.dataset.f !== 'all' && x.dataset.kind !== f.dataset.f));
      const intel = $('.cand-intel'); if (intel) intel.classList.toggle('hide', f.dataset.f !== 'all');
      return;
    }
    const v = e.target.closest('[data-v]'); if (v) {
      $$('[data-v]').forEach(b => b.classList.toggle('on', b === v));
      $$('.voice').forEach(x => x.classList.toggle('hide', v.dataset.v !== 'all' && x.dataset.type !== v.dataset.v)); return;
    }
    const gm = e.target.closest('[data-geo-mode]'); if (gm) {
      $$('[data-geo-mode]').forEach(b => b.classList.toggle('active', b === gm));
      updateGeoLayer(gm.dataset.geoMode); return;
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

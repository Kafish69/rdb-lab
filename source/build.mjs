import { PGlite } from '@electric-sql/pglite'; import fs from 'fs'; import { execSync } from 'child_process';
const R = '/home/claude/rdb/';
const py = JSON.parse(execSync(`cd ${R}src && python3 -c "import json; from exercises import EX; from quiz import QZ; from cheat import CHEAT; from learn import UNITS; print(json.dumps(dict(learn=UNITS, ex=EX, qz=QZ, cheat=[dict(t=t,b=b) for t,b in CHEAT])))"`).toString());
const seed = fs.readFileSync(R+'src/seed.sql','utf8');
const db = new PGlite(); await db.exec(seed);
// schema introspection
const schema = {};
for (const s of ['enterprise']) {
  const tabs = (await db.query(`SELECT table_name FROM information_schema.tables WHERE table_schema=$1 ORDER BY CASE table_name WHEN 'employees' THEN 1 WHEN 'departments' THEN 2 WHEN 'locations' THEN 3 WHEN 'projects' THEN 4 WHEN 'tasks' THEN 5 WHEN 'family_members' THEN 6 WHEN 'tv_show' THEN 1 WHEN 'season' THEN 2 WHEN 'movie' THEN 3 ELSE 4 END`, [s])).rows;
  schema[s] = [];
  for (const {table_name: t} of tabs) {
    const cols = (await db.query(`SELECT a.attname AS name, format_type(a.atttypid, a.atttypmod) AS type, a.attnotnull AS nn FROM pg_attribute a WHERE a.attrelid = ($1||'.'||$2)::regclass AND a.attnum > 0 AND NOT a.attisdropped ORDER BY a.attnum`, [s, t])).rows;
    const cons = (await db.query(`SELECT c.contype, a.attname, cl.relname AS ref FROM pg_constraint c JOIN pg_attribute a ON a.attrelid=c.conrelid AND a.attnum = ANY(c.conkey) LEFT JOIN pg_class cl ON cl.oid=c.confrelid WHERE c.conrelid = ($1||'.'||$2)::regclass`, [s, t])).rows;
    const n = (await db.query(`SELECT count(*)::int n FROM ${s}.${t}`)).rows[0].n;
    schema[s].push({ name: t, rows: n, cols: cols.map(c => ({ name: c.name, type: c.type.replace('character varying','varchar').replace('timestamp without time zone','timestamp').replace('character','char').replace(/numeric\((\d+),0\)/,'numeric($1)'), nn: c.nn, pk: cons.some(k => k.contype==='p' && k.attname===c.name), fk: (cons.find(k => k.contype==='f' && k.attname===c.name)||{}).ref })) });
  }
}
// validate exercises
const id = x=>x, P = {}; [16,20,21,23,700,701,1700,1082,1114,1184,1186].forEach(o=>P[o]=id);
let bad = 0;
for (const [i,e] of py.ex.entries()) { try { await db.exec('BEGIN'); await db.exec(`SET search_path TO ${e.db}; SET datestyle TO ISO, DMY;`); const r = await db.exec(e.sol,{rowMode:'array',parsers:P}); if (!r[r.length-1].rows.length) { console.log('EMPTY', i); } } catch(err) { bad++; console.log('ERR', i, err.message) } finally { await db.exec('ROLLBACK') } }
// notes
const md = fs.readFileSync(R+'src/notes.md','utf8');
const COVERS = { intro:'DB vs DBMS, keys, integrity rules, data models, SQL groups', select:'SELECT, DISTINCT, WHERE, LIKE, IN, NULL, ORDER BY, OFFSET/FETCH', functions:'TO_CHAR, TO_DATE, CAST, ROUND, dates, text functions', joins:'INNER JOIN, USING, NATURAL, non-equi and self joins', group:'COUNT, SUM, AVG, MIN, MAX, GROUP BY, HAVING', outer:'LEFT, RIGHT, FULL joins and finding what is missing', exam:'How to attack a question, the mistakes that cost points' };
const esc = s => s.replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/"/g,'&quot;');
const notes = md.split(/^@@ch /m).filter(Boolean).map(part => {
  const [head, ...rest] = part.split('\n'); const [cid, title, week] = head.split('|').map(s => s.trim());
  let html = rest.join('\n');
  html = html.replace(/```sql( netflix)?\n([\s\S]*?)```/g, (m, nf, code) => `<div class="runbox" data-db="${nf ? 'netflix' : 'enterprise'}" data-sql="${esc(code.replace(/\n$/,''))}"></div>`);
  html = html.replace(/^## (.*)$/gm, '<h2>$1</h2>');
  return { id: cid, title, week, covers: COVERS[cid] || '', html };
});
// check every runnable note snippet
for (const n of notes) for (const m of n.html.matchAll(/data-db="(\w+)" data-sql="([^"]*)"/g)) {
  const sql = m[2].replace(/&quot;/g,'"').replace(/&lt;/g,'<').replace(/&gt;/g,'>').replace(/&amp;/g,'&');
  try { await db.exec('BEGIN'); await db.exec(`SET search_path TO ${m[1]}; SET datestyle TO ISO, DMY;`); await db.exec(sql); } catch(e) { console.log('NOTE ERR', n.id, e.message, '|', sql.slice(0,70)); } finally { await db.exec('ROLLBACK'); }
}
py.ex.forEach(e => e.ord = /\b(sort|sorted|order|descending|ascending|most first|highest first|longest first|oldest first)\b|\bplaces? \d|page \d/i.test(e.q.replace(/<[^>]+>/g,'')));
// validate learn
for (const u of py.learn) for (const st of u.steps) for (const q of [st.ex, st.task && st.task.sol].filter(Boolean)) { try { await db.exec('BEGIN'); await db.exec('SET search_path TO enterprise; SET datestyle TO ISO, DMY;'); const r = await db.exec(q); if (!r[r.length-1].rows.length) console.log('LEARN EMPTY', st.t); } catch(e) { console.log('LEARN ERR', st.t, e.message) } finally { await db.exec('ROLLBACK') } }
const cfg = fs.existsSync(R+'src/cfg.json') ? JSON.parse(fs.readFileSync(R+'src/cfg.json','utf8')) : {};
const DATA = { learn: py.learn, cfg, notes, ex: py.ex, qz: py.qz, cheat: py.cheat, schema, seed };
const html = fs.readFileSync(R+'src/template.html','utf8').replace('__DATA__', () => JSON.stringify(DATA).replace(/<\/script/g,'<\\/script'));
fs.writeFileSync(R+'site/index.html', html);
console.log('built', (html.length/1024|0)+'KB', 'ex', py.ex.length, 'qz', py.qz.length, 'notes', notes.length, 'bad', bad);

# rdb.lab

Study site for **Relational Database Fundamentals** (KdG, term 1): notes for weeks 1–5, runnable SQL examples, 122 query exercises that are checked automatically, a 118-question quiz, a mock exam and a cheat sheet.

The queries run on a real PostgreSQL inside the browser ([PGlite](https://github.com/electric-sql/pglite)), so nothing needs to be installed.

The `enterprise` and `netflix` databases are practice copies. The rows differ from the ones used in class.

Live: https://kafish69.github.io/rdb-lab/

To rebuild: edit the files in `source/`, then run `node source/build.mjs` (needs `npm i @electric-sql/pglite`).

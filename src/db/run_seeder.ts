import pool from './connection';
import fs from 'fs';
import path from 'path';
// import { fileURLToPath } from 'url';
  
// const __dirname = path.dirname(fileURLToPath(import.meta.url));

async function run_sql_seed_file_by_version(ver: string): Promise<void> {
  const sql_seed_dir = path.join(__dirname, `${ver}/seeder`);
  if (!fs.existsSync(sql_seed_dir)) return;

  const sqlFiles = fs
    .readdirSync(sql_seed_dir)
    .filter((f) => f.endsWith('.sql'))
    .sort();

  for (const file of sqlFiles) {
    const sql = fs.readFileSync(path.join(sql_seed_dir, file), 'utf8');
    await pool.query(sql);
    console.log(`SQL Seeded: ${file}`);
  }
}

async function run_js_seed_function_by_version(ver: string): Promise<void> {
  const js_seed_dir = path.join(__dirname, `${ver}/seeder`);
  if (!fs.existsSync(js_seed_dir)) return;

  const tsFiles = fs
    .readdirSync(js_seed_dir)
    .filter((f) => f.startsWith('seed_') && f.endsWith('.ts'))
    .sort();

  for (const file of tsFiles) {
    const modulePath = path.join(js_seed_dir, file);
    const { default: runFn } = await import(modulePath);

    if (typeof runFn === 'function') {
      await runFn();
      console.log(`Script Seeded: ${file}`);
    } else {
      console.warn(`Skipped: ${file} (no default function export)`);
    }
  }
}

async function run_seeder(ver: string = '0.0.1'): Promise<void> {
  
  console.log('Running Seeder version: ', ver);
  await run_sql_seed_file_by_version(ver);
  await run_js_seed_function_by_version(ver);
}

run_seeder( process.env.NESTIFY_DB_VERSION || '0.0.1' )
  .then(async () => {
    console.log('All seeders done.');
    await pool.end();
    process.exit(0);
  })
  .catch(async (err) => {
    console.error('Seeding failed', err);
    await pool.end();
    process.exit(1);
  });

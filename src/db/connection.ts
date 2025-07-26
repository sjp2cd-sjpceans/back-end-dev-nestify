import mysql from 'mysql2/promise';
import * as DotEnv from 'dotenv';

export const env_file =
  process.env.NODE_ENV === 'production'
  ? '.env.production'
  : process.env.NODE_ENV === 'test'
    ? '.env.test'
    : '.env.development';

DotEnv.config({ path: env_file });

const pool = mysql.createPool({
  host: process.env.NESTIFY_DB_HOST,
  port: Number(process.env.NESTIFY_DB_PORT),
  user: process.env.NESTIFY_DB_USER,
  password: process.env.NESTIFY_DB_PASSWORD,
  database: process.env.NESTIFY_DB_NAME,
  waitForConnections: true,
  connectionLimit: 10,
  queueLimit: 0,
  multipleStatements: true,
});

export default pool;

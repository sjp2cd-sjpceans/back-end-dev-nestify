import pool from './connection';
import fs from 'fs';
import path from 'path';

async function run_migration_by_version( ver: string = '0.0.1' ): Promise<void> {

  console.log('Running Migration version: ', ver);
  
  const files: string[] = fs
    .readdirSync( path.join(__dirname, `${ver}/migration`) )
    .filter( (fileName: string ): boolean => fileName.endsWith('.sql') )
    .sort();

  for (const file of files ) {

    const sql: string = fs
      .readFileSync( 
        path.join(__dirname, `${ver}/migration`, file), 
        'utf8' 
      );
    
    await pool.query( sql );

    console.log(`Migrated: ${file}`);
  }

}

run_migration_by_version( process.env.NESTIFY_DB_VERSION || '0.0.1' )
  .then( async () => {

    console.log('Migration done.');
    process.exit(0);
  })
  .catch(err => {

    console.error("Migration failed", err);
    process.exit(1);
  });

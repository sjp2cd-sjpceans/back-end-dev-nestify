import bcrypt from 'bcrypt';
import pool  from '@dev_nestify/db/connection';

interface ClientAccountSeed {
  id: number;
  clientId: number;
  userName: string;
  rawPassword: string;
  isVerify: boolean;
  isOnline: boolean;
  isBusy: boolean;
}

async function run_seed_client_account(): Promise<void> {

  const saltRounds = 12;

  const seeds: ClientAccountSeed[] = [
    { id: 1,  clientId: 1,  userName: 'jinu',          rawPassword: 'Jinu123',          isVerify: true,  isOnline: false, isBusy: false },
    { id: 2,  clientId: 2,  userName: 'ahn_hyo_seop',    rawPassword: 'AhnHyoSeop123',    isVerify: true,  isOnline: false, isBusy: false },
    { id: 3,  clientId: 3,  userName: 'gwi_ma',         rawPassword: 'GwiMa123',         isVerify: false, isOnline: false, isBusy: false },
    { id: 4,  clientId: 4,  userName: 'lee_byung_hun',   rawPassword: 'LeeByungHun123',   isVerify: true,  isOnline: true,  isBusy: false },
    { id: 5,  clientId: 5,  userName: 'rumi',          rawPassword: 'Rumi123',          isVerify: true,  isOnline: false, isBusy: true  },
    { id: 6,  clientId: 6,  userName: 'arden_cho',      rawPassword: 'ArdenCho123',      isVerify: false, isOnline: false, isBusy: false },
    { id: 7,  clientId: 7,  userName: 'zoey',          rawPassword: 'Zoey123',          isVerify: true,  isOnline: false, isBusy: false },
    { id: 8,  clientId: 8,  userName: 'ji_young_yoo',    rawPassword: 'JiYoungYoo123',    isVerify: true,  isOnline: false, isBusy: false },
    { id: 9,  clientId: 9,  userName: 'baby_saja',      rawPassword: 'BabySaja123',      isVerify: false, isOnline: false, isBusy: false },
    { id: 10, clientId: 10, userName: 'danny_chung',    rawPassword: 'DannyChung123',    isVerify: true,  isOnline: true,  isBusy: true  },
  ];

  const hashPromises: Promise<string>[] = seeds.map(s =>
    bcrypt.hash(s.rawPassword, saltRounds)
  );

  const hashed: string[] = await Promise.all(hashPromises);

  const placeholders: string = seeds
    .map(() => '(?, ?, ?, ?, ?, ?, ?)')
    .join(',\n  ');
  const params: (string | number)[] = [];
  seeds.forEach((s, i) => {
    params.push(
      s.id,
      s.clientId,
      s.userName,
      hashed[i],
      s.isVerify ? 1 : 0,
      s.isOnline ? 1 : 0,
      s.isBusy   ? 1 : 0
    );
  });

  const sql: string = `
    INSERT INTO client_account
      (id, client_id, user_name, password, is_verify, is_online, is_busy)
    VALUES
      ${placeholders}
    ON DUPLICATE KEY UPDATE
      client_id = VALUES(client_id),
      user_name = VALUES(user_name),
      password  = VALUES(password),
      is_verify = VALUES(is_verify),
      is_online = VALUES(is_online),
      is_busy   = VALUES(is_busy);
  `;

  const conn = await pool.getConnection();
  try {
    
    await conn.query(sql, params);
    await conn.commit();
    // console.log('Seeded: client_account');
  } catch (err: unknown) {

    await conn.rollback();
    console.error('client_account seeding failed:', err);
    process.exit(1);
  } finally {

    // await pool.end();
  }
}

export default run_seed_client_account;
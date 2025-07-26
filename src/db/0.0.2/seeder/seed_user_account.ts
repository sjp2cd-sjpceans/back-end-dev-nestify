import bcrypt from 'bcrypt';
import pool from '@dev_nestify/db/connection';

interface UserAccountSeed {
  id: number;
  actorProfileId: number;
  username: string;
  rawPassword: string;
  isVerified: boolean;
  isOnline: boolean;
  isBusy: boolean;
}

async function run_seed_user_account(): Promise<void> {
  const saltRounds = 12;

  const seeds: UserAccountSeed[] = [
    { id: 1,  actorProfileId: 1,  username: 'tstark',    rawPassword: 'Password1!', isVerified: true,  isOnline: false, isBusy: false },
    { id: 2,  actorProfileId: 2,  username: 'srogers',   rawPassword: 'Password2!', isVerified: true,  isOnline: false, isBusy: false },
    { id: 3,  actorProfileId: 3,  username: 'roman_321', rawPassword: 'Password3!', isVerified: true,  isOnline: false, isBusy: false },
    { id: 4,  actorProfileId: 4,  username: 'bruce_wayne',    rawPassword: 'Password4!', isVerified: true,  isOnline: false, isBusy: false },
    { id: 5,  actorProfileId: 5,  username: 'dprince',   rawPassword: 'Password5!', isVerified: true,  isOnline: false, isBusy: false },
    { id: 6,  actorProfileId: 6,  username: 'jyoon_123',     rawPassword: 'Password6!', isVerified: true,  isOnline: false, isBusy: false },
    { id: 7,  actorProfileId: 7,  username: 'petter_park',     rawPassword: 'Password7!', isVerified: true,  isOnline: false, isBusy: false },
    { id: 8,  actorProfileId: 8,  username: 'kim_321',    rawPassword: 'Password8!', isVerified: true,  isOnline: false, isBusy: false },
    { id: 9,  actorProfileId: 9,  username: 'him_lee',      rawPassword: 'Password9!', isVerified: true,  isOnline: false, isBusy: false },
    { id: 10, actorProfileId: 10, username: 'ace_choi',     rawPassword: 'Password10!', isVerified: true, isOnline: false, isBusy: false },
  ];

  const hashedPasswords = await Promise.all(
    seeds.map((s) => bcrypt.hash(s.rawPassword, saltRounds))
  );

  const placeholders = seeds.map(() => '(?, ?, ?, ?, ?, ?, ?)').join(',\n  ');
  const params: (string | number)[] = [];

  seeds.forEach((s, i) => {
    params.push(
      s.id,
      s.actorProfileId,
      s.username,
      hashedPasswords[i],
      s.isVerified ? 1 : 0,
      s.isOnline ? 1 : 0,
      s.isBusy ? 1 : 0
    );
  });

  const sql = `
    INSERT INTO user_account
      (id, actor_profile_id, username, password_hash, is_verified, is_online, is_busy)
    VALUES
      ${placeholders}
    ON DUPLICATE KEY UPDATE
      username      = VALUES(username),
      password_hash = VALUES(password_hash),
      is_verified   = VALUES(is_verified),
      is_online     = VALUES(is_online),
      is_busy       = VALUES(is_busy);
  `;

  const conn = await pool.getConnection();
  try {
    await conn.query(sql, params);
    await conn.commit();
    // console.log('Seeded: user_account');
  } catch (err) {
    await conn.rollback();
    console.error('user_account seeding failed:', err);
    process.exit(1);
  } finally {
    // await pool.end();
  }
}

export default run_seed_user_account;

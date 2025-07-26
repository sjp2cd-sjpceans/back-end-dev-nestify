import bcrypt from 'bcrypt';
import pool  from '@dev_nestify/db/connection';

interface AgentAccountSeed {
  id: number;
  agentId: number;
  userName: string;
  rawPassword: string;
  isVerify: boolean;
  isOnline: boolean;
  isBusy: boolean;
}

async function run_seed_agent_account(): Promise<void> {

  const saltRounds = 12;

  const seeds: AgentAccountSeed[] = [
    { id: 1,  agentId: 1,  userName: 'ironman',      rawPassword: 'ironman123',      isVerify: true,  isOnline: false, isBusy: false },
    { id: 2,  agentId: 2,  userName: 'batman',       rawPassword: 'batman123',       isVerify: true,  isOnline: false, isBusy: false },
    { id: 3,  agentId: 3,  userName: 'spiderman',    rawPassword: 'spiderman123',    isVerify: false, isOnline: false, isBusy: false },
    { id: 4,  agentId: 4,  userName: 'superman',     rawPassword: 'superman123',     isVerify: true,  isOnline: true,  isBusy: false },
    { id: 5,  agentId: 5,  userName: 'wonderwoman',  rawPassword: 'wonderwoman123',  isVerify: true,  isOnline: false, isBusy: true  },
    { id: 6,  agentId: 6,  userName: 'hulk',         rawPassword: 'hulk123',         isVerify: false, isOnline: false, isBusy: false },
    { id: 7,  agentId: 7,  userName: 'flash',        rawPassword: 'flash123',        isVerify: true,  isOnline: false, isBusy: false },
    { id: 8,  agentId: 8,  userName: 'aquaman',      rawPassword: 'aquaman123',      isVerify: true,  isOnline: false, isBusy: false },
    { id: 9,  agentId: 9,  userName: 'blackwidow',   rawPassword: 'blackwidow123',   isVerify: false, isOnline: false, isBusy: false },
    { id: 10, agentId: 10, userName: 'greenlantern', rawPassword: 'greenlantern123', isVerify: true,  isOnline: true,  isBusy: true  },
  ];

  
  const hashPromises = seeds.map(s => bcrypt.hash(s.rawPassword, saltRounds));
  const hashed = await Promise.all(hashPromises);

  const placeholders = seeds.map(() => '(?, ?, ?, ?, ?, ?, ?)').join(',\n  ');
  const params: any[] = [];
  seeds.forEach((s, i) => {
    params.push(
      s.id,
      s.agentId,
      s.userName,
      hashed[i],
      s.isVerify ? 1 : 0,
      s.isOnline ? 1 : 0,
      s.isBusy ? 1 : 0
    );
  });

  const sql = `
    INSERT INTO agent_account
      (id, agent_id, user_name, password, is_verify, is_online, is_busy)
    VALUES
      ${placeholders}
    ON DUPLICATE KEY UPDATE
      agent_id   = VALUES(agent_id),
      user_name  = VALUES(user_name),
      password   = VALUES(password),
      is_verify  = VALUES(is_verify),
      is_online  = VALUES(is_online),
      is_busy    = VALUES(is_busy);
  `;

  const conn = await pool.getConnection();

  try {

    await conn.query(sql, params);
    await conn.commit();
    // console.log('Seeded: agent_account');
  } catch (err) {

    await conn.rollback();
    console.error('agent_account seeding failed:', err);
    process.exit(1);
  } finally {

    // await pool.end();
  }
}

export default run_seed_agent_account;
// import 'reflect-metadata';

import './db/connection';
import pool, { env_file } from './db/connection';

import express from 'express';
import bodyParser from 'body-parser';
// import { apiRouter } from './routes';
// import { Encryption } from './auth/Encryption';


const port = process.env.NESTIFY_API_PORT || 3000;
const hostname = 'localhost'

async function bootstrap() : Promise<void> {
  // await pool.getConnection();
  const app = express();
  app.use(bodyParser.json({ limit: '10mb' }));

  // decrypt POST bodies
  // const enc = new Encryption();
  // app.use((req, _res, next) => {
  //   if (req.method === 'POST' && req.body.encrypted) {
  //     const decrypted = enc.decrypt(req.body.encrypted);
  //     req.body = JSON.parse(decrypted);
  //   }
  //   next();
  // });

  
  app.get(['/'], (_req, res) => {
    res.send(`Welcome to the Nestify API! SERVER PORT ${process.env.NESTIFY_API_PORT}...`);
  });

  // app.use('/', apiRouter);

  app.listen(port, () => console.log(`Server: http://${hostname}:${port}/`));
}

bootstrap().catch(console.error);
import './db/connection';

import express, { Request, Response, NextFunction } from 'express';
import bodyParser from 'body-parser';

// import propertyRouter from '@dev_nestify/route/property';

const port = process.env.NESTIFY_API_PORT || 3000;
const hostname = 'localhost'

async function bootstrap() : Promise<void> {

  const app = express();
  // app.set('trust proxy', true); //REM: Trust the first proxy for secure headers
  app.use(bodyParser.json({ limit: '10mb' }));
  app.use(bodyParser.urlencoded({ limit: '10mb', extended: true, parameterLimit: 10000 }));
  app.use(bodyParser.urlencoded({ extended: true, limit: '10mb' })); //REM: For parsing application/x-www-form-urlencoded
  app.use(bodyParser.text({ limit: '10mb' })); //REM: For parsing text/plain
  app.use(bodyParser.raw({ limit: '10mb' })); //REM: For parsing application/octet-stream

  app.use('/test/asset', express.static('public/test/asset'));
  app.use('/main/asset', express.static('public/main/asset'));

  app.get(['/'], (_req, res) => {
    res.send(`Welcome to the Nestify API! SERVER PORT ${process.env.NESTIFY_API_PORT}...`);
  });

  //REM: Health-check
  app.get('/check-123', (_req: Request, res: Response) => res.send('testing, testing, 1, 2, 3...'));

  //REM: Property routes (read open; write protected)
  // app.use('/api/property', propertyRouter);

  app.use((err: any, _req: Request, res: Response, _next: NextFunction) => {
    console.error(err);
    res.status(500).json({ error: 'Internal Server Error' });
  });

  
  app.listen(port, () => {
    console.log(`Server listening on http://${hostname}:${port}`);
  });

}

bootstrap().catch(console.error);
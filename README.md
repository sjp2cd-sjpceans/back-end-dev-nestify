
## About It.
We are @dev phase

## Requirement
- `MySQL` RDBM software (Recommended: a bundle web dev tools like `XAMPP`)
- ...

## Configuring Database
#### Explicitly create new database
- `dev_nestify`
#### Configure the `.env.development`
```bash
NESTIFY_DB_VERSION=0.0.2
NESTIFY_DB_HOST=localhost
NESTIFY_DB_PORT=<port_here>
NESTIFY_DB_NAME=dev_nestify
NESTIFY_DB_USER=<db_user_name>
NESTIFY_DB_PASSWORD=<db_pass_word>
```
#### (CLI) Database migration and seeding
```bash
npm run migrate
```
```bash
npm run seed
```
  - Now check the said `(dev_nestify)` database and its corresponding `(29)` tables

## Run
```bash
#REM: In developemnt
npm run dev
```
```bash
#REM: Or in Production
npm run build
npm start
```
- Keep in mind this is only running on your local machine, and be sure to set up your `.env.production` with your live production settings, and never commit or expose it publicly.
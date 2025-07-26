
## About It.
We are @dev phase, doing basic/rudimentary Real Estate stuff.

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

### Base URLs
- **Development**: `http://localhost:3001`  
##
## Property Object API Endpoints
| Method | Endpoint                     | Auth Required | Description                          | Test |
|--------|------------------------------|---------------|--------------------------------------|--------|
| GET    | `/properties`                | No            | Get all properties                   | OK     |
| GET    | `/properties/range?offset=0&limit=5`           | No            | Get properties within a range (e.g., pagination or price range) | OK     |
| GET    | `/properties/:id`            | No            | Get a property by ID                 | OK     |
| POST   | `/properties/query`          | No            | Query properties with filters (request body) | *      |
| POST   | `/properties`                | Yes (JWT)     | Create a new property                | *      |
| PUT    | `/properties/:id`            | Yes (JWT)     | Update a property by ID              | *      |
| PUT    | `/properties`                | Yes (JWT)     | Bulk update properties               | *      |
| DELETE | `/properties/:id`            | Yes (JWT)     | Delete a property by ID              | *      |
| POST   | `/properties/delete`         | Yes (JWT)     | Delete properties by filter payload  | *      |
| POST   | `/properties/delete-ids`     | Yes (JWT)     | Delete properties by list of IDs     | *      |
---
##
## Image Object API Endpoints  
| Method  | Endpoint                   | Auth Required | Description                          | Test   |
|---------|----------------------------|---------------|--------------------------------------|--------|
| `GET`   | `/images`                  | No            | Get all images                       | OK     |
| `GET`   | `/images/range?offset=3&limit=2`            | No            | Get images within a range (e.g., pagination, date, or size range) | OK     |
| `GET`   | `/images/:id`              | No            | Get an image by ID                   | OK     |
| `POST`  | `/images/query`            | No            | Query images with filters (request body) | *      |
| `POST`  | `/images`                  | Yes (JWT)     | Upload a new image                   | *      |
| `PUT`   | `/images/:id`              | Yes (JWT)     | Update an image by ID                | *      |
| `PUT`   | `/images`                  | Yes (JWT)     | Bulk update images                   | *      |
| `DELETE`| `/images/:id`              | Yes (JWT)     | Delete an image by ID                | *      |
| `POST`  | `/images/delete`           | Yes (JWT)     | Delete images by filter payload      | *      |
| `POST`  | `/images/delete-ids`       | Yes (JWT)     | Delete images by a list of IDs       | *      |
---

### Authentication*
> Protected routes require a valid JWT in the `Authorization` header:  `Authorization: Bearer <the_token>`.
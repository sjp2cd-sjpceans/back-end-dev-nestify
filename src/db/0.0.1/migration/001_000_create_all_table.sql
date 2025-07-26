CREATE TABLE IF NOT EXISTS country (
  id              INT AUTO_INCREMENT PRIMARY KEY,
  name            VARCHAR(255) NOT NULL,
  zip_code        VARCHAR(20),
  time_zone       VARCHAR(50),
  currency_code   CHAR(3),
  created_at      DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at      DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);


CREATE TABLE IF NOT EXISTS city (
  id              INT AUTO_INCREMENT PRIMARY KEY,
  name            VARCHAR(255) NOT NULL,
  created_at      DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at      DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);


CREATE TABLE IF NOT EXISTS map_coordinate (
  id              INT AUTO_INCREMENT PRIMARY KEY,
  latitude        DECIMAL(10,7),
  longitude       DECIMAL(10,7),
  created_at      DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at      DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);


CREATE TABLE IF NOT EXISTS address (
  id                  INT AUTO_INCREMENT PRIMARY KEY,
  unit_number         VARCHAR(50),
  street              VARCHAR(255) NOT NULL,
  city_id             INT NOT NULL,
  country_id          INT NOT NULL,
  map_coordinate_id   INT,
  created_at          DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at          DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (city_id)           REFERENCES city(id),
  FOREIGN KEY (country_id)        REFERENCES country(id),
  FOREIGN KEY (map_coordinate_id) REFERENCES map_coordinate(id)
);


CREATE TABLE IF NOT EXISTS property_type (
  id              INT AUTO_INCREMENT PRIMARY KEY,
  name            VARCHAR(100) NOT NULL,
  description     TEXT,
  created_at      DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at      DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);


CREATE TABLE IF NOT EXISTS sales_office (
  id              INT AUTO_INCREMENT PRIMARY KEY,
  name            VARCHAR(255) NOT NULL,
  address_id      INT NOT NULL,
  city            VARCHAR(100),
  country         VARCHAR(100),
  zip_code        VARCHAR(20),
  email           VARCHAR(255) UNIQUE,
  phone           VARCHAR(50),
  created_at      DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at      DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (address_id) REFERENCES address(id)
);


CREATE TABLE IF NOT EXISTS agent (
  id              INT AUTO_INCREMENT PRIMARY KEY,
  first_name      VARCHAR(100),
  last_name       VARCHAR(100),
  email           VARCHAR(255) UNIQUE NOT NULL,
  phone           VARCHAR(50),
  license_number  VARCHAR(100),
  sales_office_id INT,
  created_at      DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at      DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (sales_office_id) REFERENCES sales_office(id)
);


CREATE TABLE IF NOT EXISTS agent_account (
  id              INT AUTO_INCREMENT PRIMARY KEY,
  agent_id        INT NOT NULL,
  user_name       VARCHAR(255) UNIQUE NOT NULL,
  password        VARCHAR(255) NOT NULL,
  is_verify       BOOLEAN DEFAULT FALSE,
  is_online       BOOLEAN DEFAULT FALSE,
  is_busy         BOOLEAN DEFAULT FALSE,
  created_at      DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at      DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (agent_id) REFERENCES agent(id)
);


CREATE TABLE IF NOT EXISTS owner (
  id              INT AUTO_INCREMENT PRIMARY KEY,
  first_name      VARCHAR(100),
  last_name       VARCHAR(100),
  email           VARCHAR(255) UNIQUE,
  phone           VARCHAR(50),
  address_id      INT,
  created_at      DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at      DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (address_id) REFERENCES address(id)
);


CREATE TABLE IF NOT EXISTS client (
  id              INT AUTO_INCREMENT PRIMARY KEY,
  first_name      VARCHAR(100),
  last_name       VARCHAR(100),
  email           VARCHAR(255) UNIQUE NOT NULL,
  phone           VARCHAR(50),
  address_id      INT,
  created_at      DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at      DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (address_id) REFERENCES address(id)
);


CREATE TABLE IF NOT EXISTS client_account (
  id              INT AUTO_INCREMENT PRIMARY KEY,
  client_id       INT NOT NULL,
  user_name       VARCHAR(255) UNIQUE NOT NULL,
  password        VARCHAR(255) NOT NULL,
  is_verify       BOOLEAN DEFAULT FALSE,
  is_online       BOOLEAN DEFAULT FALSE,
  is_busy         BOOLEAN DEFAULT FALSE,
  created_at      DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at      DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (client_id) REFERENCES client(id)
);


CREATE TABLE IF NOT EXISTS property (
  id                  INT AUTO_INCREMENT PRIMARY KEY,
  name                VARCHAR(255) NOT NULL,
  description         TEXT,
  address_id          INT NOT NULL,
  price               DECIMAL(15,2) NOT NULL,
  status              ENUM('available','pending','sold') DEFAULT 'available',
  had_discount        BOOLEAN DEFAULT FALSE,
  discount_price      DECIMAL(15,2),
  listed_date         DATE,
  property_type_id    INT,
  agent_id            INT,
  sales_office_id     INT,
  created_at          DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at          DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (address_id)       REFERENCES address(id),
  FOREIGN KEY (property_type_id) REFERENCES property_type(id),
  FOREIGN KEY (agent_id)         REFERENCES agent(id),
  FOREIGN KEY (sales_office_id)  REFERENCES sales_office(id)
);


CREATE TABLE IF NOT EXISTS property_owner (
  id                    INT AUTO_INCREMENT PRIMARY KEY,
  owner_id              INT NOT NULL,
  ownership_role        VARCHAR(100),
  ownership_percentage  DECIMAL(5,2),
  property_id           INT NOT NULL,
  created_at            DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at            DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (owner_id)    REFERENCES owner(id),
  FOREIGN KEY (property_id) REFERENCES property(id)
);


CREATE TABLE IF NOT EXISTS client_property_interest (
  id              INT AUTO_INCREMENT PRIMARY KEY,
  client_id       INT NOT NULL,
  property_id     INT NOT NULL,
  interest_level  VARCHAR(50),
  create_at       DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (client_id)   REFERENCES client(id),
  FOREIGN KEY (property_id) REFERENCES property(id)
);


CREATE TABLE IF NOT EXISTS appointment (
  id               INT AUTO_INCREMENT PRIMARY KEY,
  agent_id         INT NOT NULL,
  client_id        INT NOT NULL,
  appointment_type VARCHAR(100),
  scheduled_at     DATETIME,
  status           VARCHAR(50),
  property_id      INT,
  notes            TEXT,
  create_at        DATETIME DEFAULT CURRENT_TIMESTAMP,
  update_at        DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (agent_id)    REFERENCES agent(id),
  FOREIGN KEY (client_id)   REFERENCES client(id),
  FOREIGN KEY (property_id) REFERENCES property(id)
);


CREATE TABLE IF NOT EXISTS `transaction` (
  id               INT AUTO_INCREMENT PRIMARY KEY,
  agent_id         INT NOT NULL,
  client_id        INT NOT NULL,
  transaction_type VARCHAR(100),
  property_id      INT,
  amount           DECIMAL(15,2),
  status           VARCHAR(50),
  notes            TEXT,
  create_at        DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (agent_id)    REFERENCES agent(id),
  FOREIGN KEY (client_id)   REFERENCES client(id),
  FOREIGN KEY (property_id) REFERENCES property(id)
);


CREATE TABLE IF NOT EXISTS notification (
  id              INT AUTO_INCREMENT PRIMARY KEY,
  agent_id        INT,
  client_id       INT,
  message         TEXT,
  category        VARCHAR(50),
  priority        INT,
  had_read        BOOLEAN DEFAULT FALSE,
  create_at       DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (agent_id)    REFERENCES agent(id),
  FOREIGN KEY (client_id)   REFERENCES client(id)
);


CREATE TABLE IF NOT EXISTS notification_transaction (
  id               INT AUTO_INCREMENT PRIMARY KEY,
  notification_id  INT NOT NULL,
  transaction_id   INT NOT NULL,
  create_at        DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (notification_id)  REFERENCES notification(id),
  FOREIGN KEY (transaction_id)   REFERENCES `transaction`(id)
);


CREATE TABLE IF NOT EXISTS notification_appointment (
  id               INT AUTO_INCREMENT PRIMARY KEY,
  notification_id  INT NOT NULL,
  appointment_id   INT NOT NULL,
  create_at        DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (notification_id)  REFERENCES notification(id),
  FOREIGN KEY (appointment_id)   REFERENCES appointment(id)
);


CREATE TABLE IF NOT EXISTS image (
  id              INT AUTO_INCREMENT PRIMARY KEY,
  url             VARCHAR(512) NOT NULL,
  is_primary      BOOLEAN DEFAULT FALSE,
  created_at      DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at      DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);


CREATE TABLE IF NOT EXISTS image_property (
  id               INT AUTO_INCREMENT PRIMARY KEY,
  property_id      INT NOT NULL,
  image_id         INT NOT NULL,
  created_at       DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at       DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (property_id) REFERENCES property(id),
  FOREIGN KEY (image_id)    REFERENCES image(id)
);


CREATE TABLE IF NOT EXISTS image_property_owner (
  id                  INT AUTO_INCREMENT PRIMARY KEY,
  property_owner_id   INT NOT NULL,
  image_id            INT NOT NULL,
  created_at          DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at          DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (property_owner_id) REFERENCES property_owner(id),
  FOREIGN KEY (image_id)          REFERENCES image(id)
);


CREATE TABLE IF NOT EXISTS image_agent (
  id         INT AUTO_INCREMENT PRIMARY KEY,
  agent_id   INT NOT NULL,
  image_id   INT NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (agent_id) REFERENCES agent(id),
  FOREIGN KEY (image_id) REFERENCES image(id)
);


CREATE TABLE IF NOT EXISTS image_client (
  id         INT AUTO_INCREMENT PRIMARY KEY,
  client_id  INT NOT NULL,
  image_id   INT NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (client_id) REFERENCES client(id),
  FOREIGN KEY (image_id)  REFERENCES image(id)
);


CREATE TABLE IF NOT EXISTS image_sales_office (
  id              INT AUTO_INCREMENT PRIMARY KEY,
  sales_office_id INT NOT NULL,
  image_id        INT NOT NULL,
  created_at      DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at      DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (sales_office_id) REFERENCES sales_office(id),
  FOREIGN KEY (image_id)        REFERENCES image(id)
);



CREATE TABLE IF NOT EXISTS property (
  id                    INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  name                  VARCHAR(255)     NOT NULL,
  description           TEXT,
  address_id            INT UNSIGNED,
  property_type_id      INT UNSIGNED     NOT NULL,
  size                  DECIMAL(10,2)    NOT NULL,
  price                 DECIMAL(15,2)    NOT NULL,
  status_id             INT UNSIGNED     NOT NULL,
  had_discount          BOOLEAN          NOT NULL DEFAULT FALSE,
  discount_price        DECIMAL(15,2),
  actor_property_owner_id INT UNSIGNED,
  actor_sales_office_id INT UNSIGNED,
  actor_agent_id        INT UNSIGNED,
  created_at            TIMESTAMP        NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at            TIMESTAMP        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX(name),
  FOREIGN KEY (address_id)             REFERENCES address(id)               ON DELETE SET NULL,
  FOREIGN KEY (property_type_id)       REFERENCES lookup_property_type(id)  ON DELETE RESTRICT,
  FOREIGN KEY (status_id)              REFERENCES lookup_status(id)         ON DELETE RESTRICT,
  FOREIGN KEY (actor_property_owner_id)REFERENCES actor_property_owner(actor_profile_id) ON DELETE SET NULL,
  FOREIGN KEY (actor_sales_office_id)  REFERENCES actor_sales_office(id)    ON DELETE SET NULL,
  FOREIGN KEY (actor_agent_id)         REFERENCES actor_agent(actor_profile_id)       ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS actor_property_interest (
  id               INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  actor_profile_id INT UNSIGNED     NOT NULL,
  property_id      INT UNSIGNED     NOT NULL,
  interest_level   ENUM('low','medium','high') NOT NULL,
  created_at       TIMESTAMP        NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (actor_profile_id) REFERENCES actor_profile(id) ON DELETE CASCADE,
  FOREIGN KEY (property_id)      REFERENCES property(id)      ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS property_document (
  id                INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  property_id       INT UNSIGNED     NOT NULL,
  document_name     VARCHAR(255)     NOT NULL,
  lookup_type_id    INT UNSIGNED     NOT NULL,
  document_size     INT,
  is_active         BOOLEAN          NOT NULL DEFAULT TRUE,
  document_url      VARCHAR(255)     NOT NULL,
  created_at        TIMESTAMP        NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at        TIMESTAMP        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (property_id)    REFERENCES property(id)            ON DELETE CASCADE,
  FOREIGN KEY (lookup_type_id) REFERENCES lookup_document_type(id) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
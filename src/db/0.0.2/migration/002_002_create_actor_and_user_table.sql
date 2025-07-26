CREATE TABLE IF NOT EXISTS actor_profile (
  id              INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  actor_role_id   INT UNSIGNED,
  first_name      VARCHAR(100),
  middle_name     VARCHAR(100),
  last_name       VARCHAR(100),
  suffix          VARCHAR(50),
  email           VARCHAR(255) UNIQUE,
  phone           VARCHAR(20),
  description     TEXT,
  address_id      INT UNSIGNED,
  created_at      TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at      TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX(last_name),
  FOREIGN KEY (actor_role_id) REFERENCES actor_role(id) ON DELETE SET NULL,
  FOREIGN KEY (address_id)    REFERENCES address(id)    ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS user_account (
  id                INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  actor_profile_id  INT UNSIGNED,
  username          VARCHAR(100)     NOT NULL UNIQUE,
  password_hash     CHAR(60)         NOT NULL,
  is_verified       BOOLEAN          NOT NULL DEFAULT FALSE,
  is_online         BOOLEAN          NOT NULL DEFAULT FALSE,
  is_busy           BOOLEAN          NOT NULL DEFAULT FALSE,
  created_at        TIMESTAMP        NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at        TIMESTAMP        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (actor_profile_id) REFERENCES actor_profile(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS actor_client (
  actor_profile_id INT UNSIGNED PRIMARY KEY,
  created_at       TIMESTAMP        NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at       TIMESTAMP        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (actor_profile_id) REFERENCES actor_profile(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS user_client (
  id               INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  user_id          INT UNSIGNED     NOT NULL,
  actor_client_id  INT UNSIGNED,
  created_at       TIMESTAMP        NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at       TIMESTAMP        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id)         REFERENCES user_account(id)  ON DELETE CASCADE,
  FOREIGN KEY (actor_client_id) REFERENCES actor_client(actor_profile_id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS actor_sales_office (
  id               INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  name             VARCHAR(255)     NOT NULL,
  actor_profile_id INT UNSIGNED     NOT NULL,
  created_at       TIMESTAMP        NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at       TIMESTAMP        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (actor_profile_id) REFERENCES actor_profile(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS actor_agent (
  actor_profile_id      INT UNSIGNED PRIMARY KEY,
  actor_sales_office_id INT UNSIGNED,
  license_number        VARCHAR(50)     NOT NULL UNIQUE,
  performance_rating    DECIMAL(3,2)    NOT NULL DEFAULT 0.00 CHECK (performance_rating BETWEEN 0 AND 5),
  created_at            TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at            TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (actor_profile_id)      REFERENCES actor_profile(id)         ON DELETE CASCADE,
  FOREIGN KEY (actor_sales_office_id) REFERENCES actor_sales_office(id)    ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS user_agent (
  id               INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  user_id          INT UNSIGNED     NOT NULL,
  actor_agent_id   INT UNSIGNED,
  created_at       TIMESTAMP        NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at       TIMESTAMP        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id)        REFERENCES user_account(id) ON DELETE CASCADE,
  FOREIGN KEY (actor_agent_id) REFERENCES actor_agent(actor_profile_id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS actor_property_owner (
  actor_profile_id           INT UNSIGNED PRIMARY KEY,
  property_ownership_role_id INT UNSIGNED NOT NULL,
  ownership_percentage       DECIMAL(5,2) NOT NULL CHECK (ownership_percentage BETWEEN 0 AND 100),
  created_at                 TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at                 TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (actor_profile_id)           REFERENCES actor_profile(id)             ON DELETE CASCADE,
  FOREIGN KEY (property_ownership_role_id) REFERENCES property_ownership_role(id) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS user_property_owner (
  id                       INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  user_id                  INT UNSIGNED     NOT NULL,
  actor_property_owner_id  INT UNSIGNED,
  created_at               TIMESTAMP        NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at               TIMESTAMP        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id)                     REFERENCES user_account(id) ON DELETE CASCADE,
  FOREIGN KEY (actor_property_owner_id)     REFERENCES actor_property_owner(actor_profile_id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


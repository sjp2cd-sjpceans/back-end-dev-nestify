CREATE TABLE IF NOT EXISTS user_appointment (
  id                INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  user_client_id    INT UNSIGNED,
  user_agent_id     INT UNSIGNED,
  property_id       INT UNSIGNED,
  lookup_type_id    INT UNSIGNED     NOT NULL,
  scheduled_at      DATETIME         NOT NULL,
  status_id         INT UNSIGNED     NOT NULL,
  notes             TEXT,
  created_at        TIMESTAMP        NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at        TIMESTAMP        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (user_client_id)    REFERENCES user_client(id)             ON DELETE SET NULL,
  FOREIGN KEY (user_agent_id)     REFERENCES user_agent(id)              ON DELETE SET NULL,
  FOREIGN KEY (property_id)       REFERENCES property(id)                ON DELETE SET NULL,
  FOREIGN KEY (lookup_type_id)    REFERENCES lookup_appointment_type(id) ON DELETE RESTRICT,
  FOREIGN KEY (status_id)         REFERENCES lookup_status(id)           ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
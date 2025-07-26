CREATE TABLE IF NOT EXISTS user_notification (
  id                   INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  user_id              INT UNSIGNED     NOT NULL,
  lookup_notification_type_id INT UNSIGNED NOT NULL,
  content              TEXT             NOT NULL,
  is_read              BOOLEAN          NOT NULL DEFAULT FALSE,
  created_at           TIMESTAMP        NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at           TIMESTAMP        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id)    REFERENCES user_account(id)            ON DELETE CASCADE,
  FOREIGN KEY (lookup_notification_type_id)
                            REFERENCES lookup_notification_type(id) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
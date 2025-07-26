CREATE TABLE IF NOT EXISTS user_rating (
  id            INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  reviewer_id   INT UNSIGNED     NOT NULL,
  object_type   ENUM('actor','property') NOT NULL,
  object_id     INT UNSIGNED     NOT NULL,
  score         TINYINT UNSIGNED NOT NULL CHECK(score BETWEEN 1 AND 5),
  created_at    TIMESTAMP        NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (reviewer_id) REFERENCES user_account(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS user_comment (
  id            INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  commenter_id  INT UNSIGNED     NOT NULL,
  object_type   ENUM('actor','property') NOT NULL,
  object_id     INT UNSIGNED     NOT NULL,
  text          TEXT             NOT NULL,
  created_at    TIMESTAMP        NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at    TIMESTAMP        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (commenter_id) REFERENCES user_account(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

USE `db_test`;

CREATE TABLE IF NOT EXISTS `title_type` (
  `id` INT PRIMARY KEY AUTO_INCREMENT,
  `name` NVARCHAR(100) UNIQUE NOT NULL
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `title` (
  `id` NVARCHAR(10) PRIMARY KEY,
  `primaryTitle` NVARCHAR(400) NOT NULL,
  `originalTitle` NVARCHAR(400) NOT NULL,
  `forAdults` TINYINT(1) NOT NULL,
  `releaseYear` CHAR(4) NULL,
  `endYear` CHAR(4) NULL,
  `runtimeInMinutes` NUMERIC(5) NULL,
  `title_type_id` INT NOT NULL,
  INDEX `fk_title_title_type_idx` (`title_type_id` ASC) VISIBLE,
  CONSTRAINT `fk_title_title_type`
    FOREIGN KEY (`title_type_id`)
    REFERENCES `title_type` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `genre` (
  `id` INT PRIMARY KEY AUTO_INCREMENT,
  `name` NVARCHAR(100) UNIQUE NOT NULL
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `title_genres` (
  `id` INT PRIMARY KEY AUTO_INCREMENT,
  `title_id` NVARCHAR(10) NOT NULL,
  `genre_id` INT NOT NULL,
  INDEX `fk_title_genres_title_idx` (`title_id` ASC) VISIBLE,
  INDEX `fk_title_genres_genre_idx` (`genre_id` ASC) VISIBLE,
  CONSTRAINT `fk_title_genres_title`
    FOREIGN KEY (`title_id`)
    REFERENCES `title` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_title_genres_genre`
    FOREIGN KEY (`genre_id`)
    REFERENCES `genre` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `crew_member` (
  `id` NVARCHAR(10) PRIMARY KEY,
  `fullName` NVARCHAR(255) NOT NULL,
  `birthYear` CHAR(4) NULL,
  `deathYear` CHAR(4) NULL
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `crew_role` (
  `id` INT PRIMARY KEY AUTO_INCREMENT,
  `name` NVARCHAR(100) UNIQUE NOT NULL
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `title_crew` (
  `id` INT PRIMARY KEY AUTO_INCREMENT,
  `title_id` NVARCHAR(10) NOT NULL,
  `crew_member_id` NVARCHAR(10) NOT NULL,
  `crew_role_id` INT NOT NULL,
  INDEX `fk_title_crew_title_idx` (`title_id` ASC) VISIBLE,
  INDEX `fk_title_crew_crew_member_idx` (`crew_member_id` ASC) VISIBLE,
  INDEX `fk_title_crew_crew_role_idx` (`crew_role_id` ASC) VISIBLE,
  CONSTRAINT `fk_title_crew_title`
    FOREIGN KEY (`title_id`)
    REFERENCES `title` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_title_crew_crew_member`
    FOREIGN KEY (`crew_member_id`)
    REFERENCES `crew_member` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_title_crew_crew_role`
    FOREIGN KEY (`crew_role_id`)
    REFERENCES `crew_role` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `title_ratings` (
  `title_id` NVARCHAR(10) PRIMARY KEY,
  `averageRating` NUMERIC(3,1) NOT NULL,
  `votesNumber` INT NOT NULL,
  INDEX `fk_title_ratings_title_idx` (`title_id` ASC) VISIBLE,
  CONSTRAINT `fk_title_ratings_title`
    FOREIGN KEY (`title_id`)
    REFERENCES `title` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE = InnoDB;
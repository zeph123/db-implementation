
USE db_test;

CREATE TABLE title_type (
    id INT PRIMARY KEY IDENTITY (1, 1),
    name VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE title (
    id VARCHAR(10) PRIMARY KEY,
    primaryTitle VARCHAR(400) NOT NULL,
    originalTitle VARCHAR(400) NOT NULL,
    forAdults BIT NOT NULL,
    releaseYear CHAR(4) NULL,
    endYear CHAR(4) NULL,
    runtimeInMinutes NUMERIC(5) NULL,
    title_type_id INT NOT NULL,
    CONSTRAINT fk_title_title_type
        FOREIGN KEY (title_type_id)
        REFERENCES title_type (id)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
);
CREATE INDEX fk_title_title_type_idx ON title (title_type_id ASC);

CREATE TABLE genre (
    id INT PRIMARY KEY IDENTITY (1, 1),
    name VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE title_genres (
    id INT PRIMARY KEY IDENTITY (1, 1),
    title_id VARCHAR(10) NOT NULL,
    genre_id INT NOT NULL,
    CONSTRAINT fk_title_genres_title
        FOREIGN KEY (title_id)
        REFERENCES title (id)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION,
    CONSTRAINT fk_title_genres_genre
        FOREIGN KEY (genre_id)
        REFERENCES genre (id)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
);
CREATE INDEX fk_title_genres_title_idx ON title_genres (title_id ASC);
CREATE INDEX fk_title_genres_genre_idx ON title_genres (genre_id ASC);

CREATE TABLE crew_member (
    id VARCHAR(10) PRIMARY KEY,
    fullName VARCHAR(255) NOT NULL,
    birthYear CHAR(4) NULL,
    deathYear CHAR(4) NULL
);

CREATE TABLE crew_role (
    id INT PRIMARY KEY IDENTITY (1, 1),
    name VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE title_crew (
    id INT PRIMARY KEY IDENTITY (1, 1),
    title_id VARCHAR(10) NOT NULL,
    crew_member_id VARCHAR(10) NOT NULL,
    crew_role_id INT NOT NULL,
    CONSTRAINT fk_title_crew_title
        FOREIGN KEY (title_id)
        REFERENCES title (id)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION,
    CONSTRAINT fk_title_crew_crew_member
        FOREIGN KEY (crew_member_id)
        REFERENCES crew_member (id)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION,
    CONSTRAINT fk_title_crew_crew_role
        FOREIGN KEY (crew_role_id)
        REFERENCES crew_role (id)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
);
CREATE INDEX fk_title_crew_title_idx ON title_crew (title_id ASC);
CREATE INDEX fk_title_crew_crew_member_idx ON title_crew (crew_member_id ASC);
CREATE INDEX fk_title_crew_crew_role_idx ON title_crew (crew_role_id ASC);

CREATE TABLE title_ratings (
    title_id VARCHAR(10) PRIMARY KEY,
    averageRating NUMERIC(3,1) NOT NULL,
    votesNumber INT NOT NULL,
    CONSTRAINT fk_title_ratings_title
        FOREIGN KEY (title_id)
        REFERENCES title (id)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
);
CREATE INDEX fk_title_ratings_title_idx ON title_ratings (title_id ASC);

CREATE TABLE C##admin.title_type (
    id NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    name NVARCHAR2(100) UNIQUE NOT NULL
);

CREATE TABLE C##admin.title (
    id NVARCHAR2(10) PRIMARY KEY,
    primaryTitle NVARCHAR2(400) NOT NULL,
    originalTitle NVARCHAR2(400) NOT NULL,
    forAdults NUMBER(1) NOT NULL,
    releaseYear CHAR(4) NULL,
    endYear CHAR(4) NULL,
    runtimeInMinutes NUMBER(5) NULL,
    title_type_id NUMBER NOT NULL,
    CONSTRAINT fk_title_title_type
        FOREIGN KEY (title_type_id)
        REFERENCES C##admin.title_type (id)
);
CREATE INDEX fk_title_title_type_idx ON C##admin.title (title_type_id ASC);

CREATE TABLE C##admin.genre (
    id NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    name NVARCHAR2(100) UNIQUE NOT NULL
);

CREATE TABLE C##admin.title_genres (
    id NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    title_id NVARCHAR2(10) NOT NULL,
    genre_id NUMBER NOT NULL,
    CONSTRAINT fk_title_genres_title
        FOREIGN KEY (title_id)
        REFERENCES C##admin.title (id),
    CONSTRAINT fk_title_genres_genre
        FOREIGN KEY (genre_id)
        REFERENCES C##admin.genre (id)
);
CREATE INDEX fk_title_genres_title_idx ON C##admin.title_genres (title_id ASC);
CREATE INDEX fk_title_genres_genre_idx ON C##admin.title_genres (genre_id ASC);

CREATE TABLE C##admin.crew_member (
    id NVARCHAR2(10) PRIMARY KEY,
    fullName NVARCHAR2(255) NOT NULL,
    birthYear CHAR(4) NULL,
    deathYear CHAR(4) NULL
);

CREATE TABLE C##admin.crew_role (
    id NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    name NVARCHAR2(100) UNIQUE NOT NULL
);

CREATE TABLE C##admin.title_crew (
    id NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    title_id NVARCHAR2(10) NOT NULL,
    crew_member_id NVARCHAR2(10) NOT NULL,
    crew_role_id NUMBER NOT NULL,
    CONSTRAINT fk_title_crew_title
        FOREIGN KEY (title_id)
        REFERENCES C##admin.title (id),
    CONSTRAINT fk_title_crew_crew_member
        FOREIGN KEY (crew_member_id)
        REFERENCES C##admin.crew_member (id),
    CONSTRAINT fk_title_crew_crew_role
        FOREIGN KEY (crew_role_id)
        REFERENCES C##admin.crew_role (id)
);
CREATE INDEX fk_title_crew_title_idx ON C##admin.title_crew (title_id ASC);
CREATE INDEX fk_title_crew_crew_member_idx ON C##admin.title_crew (crew_member_id ASC);
CREATE INDEX fk_title_crew_crew_role_idx ON C##admin.title_crew (crew_role_id ASC);

CREATE TABLE C##admin.title_ratings (
    title_id NVARCHAR2(10) PRIMARY KEY,
    averageRating NUMBER(3,1) NOT NULL,
    votesNumber NUMBER NOT NULL,
    CONSTRAINT fk_title_ratings_title
        FOREIGN KEY (title_id)
        REFERENCES C##admin.title (id)
);
CREATE TABLE sources (
    name     VARCHAR(255) NOT NULL UNIQUE,
    hostname VARCHAR(255) NOT NULL
);

CREATE TABLE posts (
    title     VARCHAR(255) NOT NULL,
    url       VARCHAR(255) NOT NULL,
    source    VARCHAR(255) NOT NULL,
    important BOOLEAN      NOT NULL,
    italic    BOOLEAN      NOT NULL
);

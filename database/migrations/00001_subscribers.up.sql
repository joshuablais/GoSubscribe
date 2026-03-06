-- 000001_create_subscribers.up.sql
CREATE TABLE subscribers (
    id          BIGSERIAL PRIMARY KEY,
    email       TEXT NOT NULL UNIQUE,
    name        TEXT,
    confirmed   BOOLEAN NOT NULL DEFAULT FALSE,
    token       TEXT UNIQUE,
    created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

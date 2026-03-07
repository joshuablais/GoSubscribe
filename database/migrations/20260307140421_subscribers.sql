-- +goose Up
-- +goose StatementBegin
CREATE TABLE subscribers (
    id          BIGSERIAL PRIMARY KEY,
    email       TEXT NOT NULL UNIQUE,
    name        TEXT,
    confirmed   BOOLEAN NOT NULL DEFAULT FALSE,
    token       TEXT UNIQUE,
    created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
-- +goose StatementEnd

-- +goose Down
-- +goose StatementBegin
DROP TABLE IF EXISTS subscribers;
-- +goose StatementEnd

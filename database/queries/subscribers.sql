-- name: CreateSubscriber :one
INSERT INTO subscribers (email, name, token)
VALUES ($1, $2, $3)
RETURNING *;

-- name: GetSubscriberByEmail :one
SELECT * FROM subscribers
WHERE email = $1;

-- name: GetSubscriberByToken :one
SELECT * FROM subscribers
WHERE token = $1;

-- name: ConfirmSubscriber :one
UPDATE subscribers
SET confirmed = TRUE, token = NULL, updated_at = NOW()
WHERE token = $1
RETURNING *;

-- name: DeleteSubscriber :exec
DELETE FROM subscribers
WHERE email = $1;

-- name: ListConfirmedSubscribers :many
SELECT * FROM subscribers
WHERE confirmed = TRUE
ORDER BY created_at DESC;

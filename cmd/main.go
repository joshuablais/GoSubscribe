package main

import (
	"github.com/jackc/pgx/v5/pgxpool"
	"github.com/joshuablais/GoSubscribe/handlers"
	"github.com/joshuablais/GoSubscribe/initializers"
	"net/http"
)

func init() {
	initializers.LoadEnvVars()
	initializers.InitPostgres()
	initializers.SyncDatabase()
	initializers.InitResend()
}

func main() {
	// Echo instance
	cfg := config.LoadConfig()
	mux := http.NewServeMux()

	// Static file serving
	mux.Handle("GET /static/", http.StripPrefix("/static/", http.FileServer(http.Dir("static"))))

	Routes(mux, cfg)

	// Routes
	slog.Info("starting server", "addr", ":3001")
	if err := http.ListenAndServe(":3001", mux); err != nil {
		slog.Error("server error", "err", err)
		os.Exit(1)
	}
}

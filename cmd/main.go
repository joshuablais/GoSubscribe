package main

import (
	"github.com/jblais493/Boilerplate/handlers"
	"github.com/joshuablais/GoSubscribe/initializers"
	"github.com/labstack/echo/v4"
	_ "github.com/lib/pq"
)

func init() {
	initializers.LoadEnvVars()
	initializers.InitPostgres()
	initializers.SyncDatabase()
	initializers.InitResend()
}

func main() {
	// Echo instance
	e := echo.New()
	e.Static("/public", "public")

	// Routes from routes.go
	handlers.Routes(e)

	e.HTTPErrorHandler = handlers.LostPage
	// Start server
	e.Logger.Fatal(e.Start(":1323"))
}

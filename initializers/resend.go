package initializers

import (
	"fmt"
	"github.com/resend/resend-go/v3"
	"os"
)

var ResendClient *resend.Client

func InitResend() {
	apiKey := os.Getenv("RESEND_API_KEY")
	if apiKey == "" {
		panic("Resend API key not provided")
	}

	ResendClient = resend.NewClient(apiKey)
	fmt.Println("Resend initialized successfully")
}

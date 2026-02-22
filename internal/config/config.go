// /internal/config/config.go
package config

import (
	"github.com/joshuablais/precipice/internal/assets"
	"os"
	"path/filepath"
)

type Config struct {
	SiteName        string
	AnalyticsURL    string
	WebsiteID       string
	IconURL         string
	Token           string
	BlogDir         string
	Environment     string
	SiteURL         string
	SiteDescription string
	AssetManager    *assets.Manager
	Author          string
}

func LoadConfig() *Config {
	return &Config{
		SiteName:        getEnv("SITE_NAME", "PrecipiceUI"),
		AnalyticsURL:    getEnv("ANALYTICS_URL", "https://stats.labrynth.org/script.js"),
		WebsiteID:       getEnv("WEBSITE_ID", ""),
		IconURL:         getEnv("ICON_URL", "https://cella.b-cdn.net/precipiceUI/precipice.png"),
		Token:           getEnv("TOKEN", "12345"),
		BlogDir:         getEnv("BLOG_DIR", defaultBlogDir()),
		Environment:     getEnv("ENVIRONMENT", "development"),
		SiteURL:         getEnv("SITE_URL", "https://yoursite.com"),
		SiteDescription: getEnv("SITE_DESCRIPTION", "My awesome blog"),
		AssetManager:    assets.NewManager(),
		Author:          getEnv("AUTHOR", "Your Name"),
	}
}

func defaultBlogDir() string {
	// Default to ui/pages/blog relative to working directory
	wd, err := os.Getwd()
	if err != nil {
		return "ui/pages/blog/posts"
	}
	return filepath.Join(wd, "ui", "pages", "blog", "posts")
}

func getEnv(key, defaultValue string) string {
	if value := os.Getenv(key); value != "" {
		return value
	}
	return defaultValue
}

# Ruby Weather Scraper

A simple Ruby weather application that fetches current weather data using Nokogiri and wttr.in service.

![Weather Scraper Demo](image.png)

## Prerequisites

- Ruby 2.7 or higher
- Bundler for dependency management

## Installation

1. Clone this repository

2. Install dependencies:
```bash
bundle install
```

## Usage

Fetch current weather data for any city worldwide.

**Full ASCII Art Weather:**
```bash
ruby weather_scraper.rb Mumbai
```

**Simple One-Line Format:**
```bash
ruby weather_scraper.rb Mumbai --simple
```
Output: `Mumbai: Clear +32°C`

**Detailed JSON Format:**
```bash
ruby weather_scraper.rb "New York" --json
```
Returns structured data including temperature (C/F), humidity, wind speed, visibility, and conditions.

**Plain Text Format:**
```bash
ruby weather_scraper.rb Tokyo --plain
```

**Custom Field Format:**
```bash
ruby weather_scraper.rb London --custom
```

**Debug Mode:**
```bash
ruby weather_scraper.rb Paris --debug
```

**Format Options:**
- `--full` - Full ASCII art weather display (default)
- `--simple` - Compact one-line format
- `--plain` - Plain text detailed format
- `--custom` - Custom format with specific fields
- `--json` - JSON format with complete weather data
- `--debug` - Display debug information


## Features

- Multiple output formats (ASCII art, JSON, plain text, custom)
- Real-time weather data from wttr.in
- Support for any city worldwide
- No API key required
- Simple command-line interface

## How It Works

Uses Nokogiri to parse HTML from wttr.in and extract weather information. wttr.in is a terminal-friendly weather service that provides data in multiple formats without requiring an API key.

## Troubleshooting

**Issue**: Cannot load nokogiri

**Solution**: Run ``bundle install``

**Issue**: No weather data returned

**Solution**: Try debug mode ``ruby weather_scraper.rb <city> --debug``

**Issue**: City not recognized

**Solution**: Use full city names or try major cities

## Tech Stack

- Ruby
- Nokogiri - HTML parsing
- Open-URI - HTTP requests
- wttr.in - Weather data source

## License

Educational project. Use responsibly.

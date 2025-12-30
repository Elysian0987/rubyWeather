require 'nokogiri'
require 'open-uri'

def scrape_weather(city, format: 'full', debug: false)
  # Using wttr.in - a scraper-friendly weather service
  # Format options:
  #   'full' - Full ASCII art weather display (HTML)
  #   'simple' - One-line format (format=3)
  #   'plain' - Plain text format (format=4)
  #   'json' - JSON format for parsing
  
  user_agent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/119.0.0.0 Safari/537.36"
  
  case format
  when 'simple'
    # Format 3: Simple one-line output
    url = "https://wttr.in/#{URI.encode_www_form_component(city)}?format=3"
    puts "Fetching: #{url}" if debug
    
    begin
      response = URI.open(url, "User-Agent" => user_agent).read
      puts "\n" + "="*60
      puts "Weather for: #{city.capitalize}"
      puts "="*60
      puts response
      puts "="*60
    rescue => e
      puts "❌ Error: #{e.message}"
    end
    
  when 'plain'
    # Format 4: Plain text detailed
    url = "https://wttr.in/#{URI.encode_www_form_component(city)}?format=4"
    puts "Fetching: #{url}" if debug
    
    begin
      response = URI.open(url, "User-Agent" => user_agent).read
      puts "\n" + "="*60
      puts "Weather for: #{city.capitalize}"
      puts "="*60
      puts response
      puts "="*60
    rescue => e
      puts "❌ Error: #{e.message}"
    end
    
  when 'custom'
    # Custom format with specific fields
    # %c - weather condition, %t - temperature, %w - wind, %h - humidity
    url = "https://wttr.in/#{URI.encode_www_form_component(city)}?format=%l:+%c+%t+%w+%h"
    puts "Fetching: #{url}" if debug
    
    begin
      response = URI.open(url, "User-Agent" => user_agent).read
      puts "\n" + "="*60
      puts "Weather Details"
      puts "="*60
      puts response
      puts "="*60
    rescue => e
      puts "❌ Error: #{e.message}"
    end
    
  when 'json'
    # JSON format for programmatic parsing
    url = "https://wttr.in/#{URI.encode_www_form_component(city)}?format=j1"
    puts "Fetching: #{url}" if debug
    
    begin
      require 'json'
      response = URI.open(url, "User-Agent" => user_agent).read
      data = JSON.parse(response)
      
      current = data['current_condition'][0]
      location = data['nearest_area'][0]
      
      puts "\n" + "="*60
      puts "Weather for: #{location['areaName'][0]['value']}, #{location['country'][0]['value']}"
      puts "="*60
      puts "🌡️  Temperature: #{current['temp_C']}°C (#{current['temp_F']}°F)"
      puts "☁️  Condition: #{current['weatherDesc'][0]['value']}"
      puts "💨 Wind: #{current['windspeedKmph']} km/h #{current['winddir16Point']}"
      puts "💧 Humidity: #{current['humidity']}%"
      puts "👁️  Visibility: #{current['visibility']} km"
      puts "🌡️  Feels Like: #{current['FeelsLikeC']}°C"
      puts "="*60
    rescue JSON::ParserError => e
      puts "❌ Error parsing JSON: #{e.message}"
    rescue => e
      puts "❌ Error: #{e.message}"
    end
    
  else # 'full' - HTML with ASCII art
    url = "https://wttr.in/#{URI.encode_www_form_component(city)}"
    puts "Fetching: #{url}" if debug
    
    begin
      html = URI.open(url, "User-Agent" => user_agent).read
      doc = Nokogiri::HTML(html)

      if debug
        puts "\n=== DEBUG MODE ==="
        puts "Page title: #{doc.at_css('title')&.text}"
        puts "Found #{doc.css('pre').length} <pre> elements"
        puts "================\n"
      end

      # wttr.in returns weather data in a <pre> tag with ASCII art
      weather_data = doc.at_css('pre')&.text
      
      if weather_data && !weather_data.empty?
        puts "\n" + "="*60
        puts "Weather for: #{city.capitalize}"
        puts "="*60
        puts weather_data
        puts "="*60
        
        # Also extract specific elements using Nokogiri
        if weather_data =~ /(\d+)°C/
          puts "\n📊 Extracted Details (using Nokogiri):"
          temps = weather_data.scan(/(\d+)°C/).flatten.uniq
          temps.first(3).each_with_index do |temp, i|
            puts "  Temperature reading #{i + 1}: #{temp}°C"
          end
        end
      else
        puts "\n❌ Could not find weather data for '#{city}'."
        puts "The city name might be incorrect or not recognized."
      end
      
    rescue OpenURI::HTTPError => e
      puts "❌ HTTP Error: #{e.message}"
      puts "The city name might be invalid or the service is unavailable."
    rescue => e
      puts "❌ Error: #{e.message}"
      puts "Debug: #{e.class}" if debug
      puts e.backtrace.first(3) if debug
    end
  end
end

# Main execution
if __FILE__ == $0
  if ARGV.empty?
    puts "\nUsage: ruby weather_scraper.rb <city_name> [options]"
    puts "\nExamples:"
    puts "  ruby weather_scraper.rb Mumbai"
    puts "  ruby weather_scraper.rb \"New York\" --simple"
    puts "  ruby weather_scraper.rb Tokyo --json"
    puts "  ruby weather_scraper.rb London --debug"
    puts "\nFormat Options:"
    puts "  --full     Full ASCII art weather (default)"
    puts "  --simple   One-line simple format"
    puts "  --plain    Plain text detailed format"
    puts "  --custom   Custom format with specific fields"
    puts "  --json     JSON format with detailed data"
    puts "  --debug    Show debug information"
    puts
    exit 1
  end
  
  debug_mode = ARGV.include?("--debug")
  
  # Determine format
  format = if ARGV.include?("--simple")
    'simple'
  elsif ARGV.include?("--plain")
    'plain'
  elsif ARGV.include?("--custom")
    'custom'
  elsif ARGV.include?("--json")
    'json'
  else
    'full'
  end
  
  # Get city name (exclude flag arguments)
  city_args = ARGV.reject { |arg| arg.start_with?("--") }
  city = city_args.join(" ")
  
  scrape_weather(city, format: format, debug: debug_mode)
end

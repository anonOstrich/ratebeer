class WeatherApi
  def self.weather_in(city)
    return nil if city.empty?

    city = city.downcase
    Rails.cache.fetch("#{city}_weather", expires_in: 1.day) { get_weather_in(city) }
  end

  def self.get_weather_in(city)
    url = "http://api.apixu.com/v1/current.json?key=#{key}&q="
    response = HTTParty.get "#{url}#{ERB::Util.url_encode(city)}"
    response = response.parsed_response
    location_information = response["location"]
    weather_information = response["current"]
    result = {}
    result["city"] = location_information["name"]
    result["temperature"] = weather_information["temp_c"]
    result["icon_url"] = weather_information["condition"]["icon"]
    result["wind_speed"] = (weather_information["wind_kph"] / 3.6).round(1)
    result["wind_direction"] = weather_information["wind_dir"]
    result
  end

  def self.key
    raise "WEATHER_APIKEY env variable not defined" if ENV['WEATHER_APIKEY'].nil?

    ENV['WEATHER_APIKEY']
  end
end

require 'uri'
require 'net/http'

uri = URI.parse('https://www.example.com')
response = Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
  request = Net::HTTP::Get.new uri
  request.basic_auth('username', 'password')
  http.request request
end

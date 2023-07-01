require 'uri'
require 'net/http'

uri = URI.parse('https://www.example.com')
pem = File.read("/path/to/my.pem")
cert = OpenSSL::X509::Certificate.new(pem)
key = OpenSSL::PKey::RSA.new(pem)
response = Net::HTTP.start(uri.host, uri.port, use_ssl: true,
                           cert: cert, key: key) do |http|
  request = Net::HTTP::Get.new uri
  http.request request
end

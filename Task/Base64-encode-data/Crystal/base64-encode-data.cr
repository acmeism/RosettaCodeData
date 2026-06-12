require "http/client"
require "base64"

response = HTTP::Client.get "https://rosettacode.org/favicon.ico"
if response.success?
    Base64.encode(response.body, STDOUT)
end

require 'uri'
puts URI.encode_www_form_component("http://foo bar/").gsub("+", "%20")
# => "http%3A%2F%2Ffoo%20bar%2F"

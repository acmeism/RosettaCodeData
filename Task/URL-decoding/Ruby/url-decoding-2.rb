require 'uri'
puts URI.decode_www_form_component("http%3A%2F%2Ffoo%20bar%2F")
# => "http://foo bar/"

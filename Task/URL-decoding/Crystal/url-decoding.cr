require "uri"

puts URI.decode "http%3A%2F%2Ffoo%20bar%2F"
puts URI.decode "google.com/search?q=%60Abdu%27l-Bah%C3%A1"

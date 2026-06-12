require 'open-uri'
require 'base64'

puts Base64.encode64 open('http://rosettacode.org/favicon.ico') {|f| f.read}

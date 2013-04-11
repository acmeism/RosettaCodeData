require 'open-uri'

print open("http://rosettacode.org") {|f| f.read}

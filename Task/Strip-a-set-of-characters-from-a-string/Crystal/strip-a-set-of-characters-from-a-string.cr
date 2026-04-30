string = "She was a soul stripper. She took my heart!"

puts "With built-in #delete:  " + string.delete("aei")
puts "With ad-hoc expression: " + string.chars.reject(&.in? "aei").join

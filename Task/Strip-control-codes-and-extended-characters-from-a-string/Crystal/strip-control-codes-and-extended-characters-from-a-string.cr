string = "abcd\t\n efgh\x00\x01\x7f áéíóú ijklm\n"

no_control_codes   = string.delete("\x00-\x1f\x7f")
nor_extended_chars = string.delete("^ -~")

puts "original:          #{string.inspect}"
puts "w/o control codes: #{no_control_codes.inspect}"
puts "w/o either:        #{nor_extended_chars.inspect}"

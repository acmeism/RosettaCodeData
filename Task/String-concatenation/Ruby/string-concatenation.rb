s = "hello"

puts "#{s} template"       #=> "hello template"
# Variable s is intact
puts s                     #=> "hello"

puts s + " literal"        #=> "hello literal"
# Variable s is still the same
puts s                     #=> "hello"

# Mutating s variable:

s += " literal"
puts s                     #=> "hello literal"
s << " another" # append to s, use only when string literals are not frozen
puts s                     #=> "hello literal another"

s = "hello"
puts s.concat(" literal")  #=> "hello literal"
puts s                     #=> "hello literal"
puts s.prepend("Alice said: ")  #=> "Alice said: hello literal"
puts s                     #=> "Alice said: hello literal"

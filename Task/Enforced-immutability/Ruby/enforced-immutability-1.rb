msg = "Hello World"
msg << "!"
puts msg                #=> Hello World!

puts msg.frozen?        #=> false
msg.freeze
puts msg.frozen?        #=> true
begin
  msg << "!"
rescue => e
  p e                   #=> #<RuntimeError: can't modify frozen String>
end

puts msg                #=> Hello World!
msg2 = msg

# The object is frozen, not the variable.
msg = "hello world"     # A new object was assigned to the variable.

puts msg.frozen?        #=> false
puts msg2.frozen?       #=> true

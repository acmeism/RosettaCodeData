if false
  puts "false"
elsif nil
  puts "nil"
elsif Pointer(Nil).new 0
  puts "null pointer"
elsif true && "any other value"
  puts "finally true!"
end

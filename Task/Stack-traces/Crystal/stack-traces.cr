def method1
  method2
end

def method2
  puts caller.join("\n")
end

def method0
  method1
end

puts "-------"
method0
puts "-------"

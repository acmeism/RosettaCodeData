def print_type(x)
  puts "Compile-time type of #{x} is #{typeof(x)}"
  puts "    Actual runtime type is #{x.class}" if x.class != typeof(x)
end

print_type 123
print_type 123.45
print_type  rand < 0.5 ? "1" : 0
print_type rand < 1.5
print_type nil
print_type 'c'
print_type "str"
print_type [1,2]
print_type({ 2, "two" })
print_type({a: 1, b: 2})
print_type ->(x : Int32){ x+2 > 0 }

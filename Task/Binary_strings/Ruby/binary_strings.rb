# string creation
x = "hello world"

# string destruction
x = nil

# string assignment with a null byte
x = "a\0b"
x.length  # ==> 3

# string comparison
if x == "hello"
  puts equal
else
  puts "not equal"
end
y = 'bc'
if x < y
  puts "#{x} is lexicographically less than #{y}"
end

# string cloning
xx = x.dup
x == xx       # true, same length and content
x.equal?(xx)  # false, different objects

# check if empty
if x.empty?
  puts "is empty"
end

# append a byte
x << "\07"

# substring
xx = x[0..-2]

# replace bytes
y = "hello world".tr("l", "L")

# join strings
a = "hel"
b = "lo w"
c = "orld"
d = a + b + c

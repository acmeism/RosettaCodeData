# String creation
x = "hello world"

# String destruction
x = nil

# String assignment with a null byte
x = "a\0b"
IO.inspect x                  #=> <<97, 0, 98>>
IO.puts String.length(x)      #=> 3

# string comparison
if x == "hello" do
  IO.puts "equal"
else
  IO.puts "not equal"         #=> not equal
end
y = "bc"
if x < y do
  IO.puts "#{x} is lexicographically less than #{y}"  #=> a b is lexicographically less than bc
end

# string cloning
xx = x
IO.puts x == xx               #=> true  （same length and content)

# check if empty
if x=="" do
  IO.puts "is empty"
end
if String.length(x)==0 do
  IO.puts "is empty"
end

# append a byte
IO.puts x <> "\07"            #=> a b 7
IO.inspect x <> "\07"         #=> <<97, 0, 98, 0, 55>>

# substring
IO.puts String.slice("elixir", 1..3)          #=> lix
IO.puts String.slice("elixir", 2, 3)          #=> ixi

# replace bytes
IO.puts String.replace("a,b,c", ",", "-")     #=> a-b-c

# string interpolation
a = "abc"
n = 100
IO.puts "#{a} : #{n}"         #=> abc : 100

# join strings
a = "hel"
b = "lo w"
c = "orld"
IO.puts a <> b <> c           #=> hello world

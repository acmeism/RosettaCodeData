# String assignment. Creation and garbage collection are automatic.
a = "123\x00 abc "  # strings can contain bytes that are not printable in the local font
b = "456" * '\x09'
c = "789"
println(a)
println(b)
println(c)

# string comparison
println("(a == b) is $(a == b)")

# String copying.
A = a
B = b
C = c
println(A)
println(B)
println(C)

# check if string is empty
if length(a) == 0
println("string a is empty")
else
println("string a is not empty")
end

# append a byte (actually this is a Char in Julia, and may also be up to 32 bit Unicode) to a string
a= a * '\x64'
println(a)

# extract a substring from string
e = a[1:6]
println(e)

# repeat strings with ^
b4 = b ^ 4
println(b4)

# Replace every occurrence of a string in another string with third string
r = replace(b4, "456" => "xyz")
println(r)

# join strings with *
d = a * b * c
println(d)

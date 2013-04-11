sequence baseString, subString, findString
integer findChar
integer m, n

baseString = "abcdefghijklmnopqrstuvwxyz"

-- starting from n characters in and of m length;
n = 12
m = 5
subString = baseString[n..n+m-1]
puts(1, subString )
puts(1,'\n')

-- starting from n characters in, up to the end of the string;
n = 12
subString = baseString[n..$]
puts(1, subString )
puts(1,'\n')

-- whole string minus last character;
subString = baseString[1..$-1]
puts(1, subString )
puts(1,'\n')

-- starting from a known character within the string and of m length;
findChar = 'o'
m = 5
n = find(findChar,baseString)
subString = baseString[n..n+m-1]
puts(1, subString )
puts(1,'\n')

-- starting from a known substring within the string and of m length.
findString = "pq"
m = 5
n = match(findString,baseString)
subString = baseString[n..n+m-1]
puts(1, subString )
puts(1,'\n')

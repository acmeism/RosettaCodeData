-- create an empty string 3 different ways
str = ""
str = ''
str = [[]]

-- test for empty string
if str == "" then
  print "The string is empty"
end

-- test for nonempty string
if str ~= "" then
  print "The string is not empty"
end

-- several different ways to check the string's length
if string.len(str) == 0 then
  print "The library function says the string is empty."
end
if str:len() == 0 then
  print "The method call says the string is empty."
end
if #str == 0 then
  print "The unary operator says the string is empty."
end

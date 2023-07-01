local chars = {"G","o","o","d","b","y","e",","," ","W","o","r","l","d","!"}
for i = 1, #chars do
  io.write(chars[i])
end
-- or:
print(table.concat(chars))

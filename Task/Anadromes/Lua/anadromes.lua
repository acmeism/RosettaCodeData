word_list = {}

for line in io.lines("words.txt") do
   if #line > 6 then word_list[line] = true end
end

for word in pairs(word_list) do
   local rev = string.reverse(word)
   if word > rev and word_list[rev] then
      io.write(string.format("%-10s %s \n", word, rev))
   end
end

minOddWordLength = 5
minWordLength    = minOddWordLength*2-1

dict = {}
for word in io.lines('unixdict.txt') do
  local n = #word
  if n >= minOddWordLength then -- skip words that are too short
    dict[word] = n
  end
end

for word, len in pairs(dict) do
  if len >= minWordLength then
    local odd  = ""
    for o, _ in word:gmatch("(.)(.?)") do
      odd = odd .. o
    end
    if dict[odd] then
      print(string.format("%10s → %s", word, odd))
    end
  end
end

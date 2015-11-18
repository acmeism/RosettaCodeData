function sort(word)
  local bytes = {word:byte(1, -1)}
  table.sort(bytes)
  return string.char(unpack(bytes))
end

-- Read in and organize the words.
-- word_sets[<alphabetized_letter_list>] = {<words_with_those_letters>}
local word_sets = {}
local max_size = 0
for word in io.lines('unixdict.txt') do
  local key = sort(word)
  if word_sets[key] == nil then word_sets[key] = {} end
  table.insert(word_sets[key], word)
  max_size = math.max(max_size, #word_sets[key])
end

-- Print out the answer sets.
for _, word_set in pairs(word_sets) do
  if #word_set == max_size then
    for _, word in pairs(word_set) do io.write(word .. ' ') end
    print('')  -- Finish with a newline.
  end
end

function lexNums (limit)
  local numbers = {}
  for i = 1, limit do
    table.insert(numbers, tostring(i))
  end
  table.sort(numbers)
  return numbers
end

local numList = lexNums(13)
print(table.concat(numList, " "))

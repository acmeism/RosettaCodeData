local nums = {
  {1,2,0},
  {3,4,-1,1},
  {7,8,9,11,12}
}

local missingInts, i = {}

function notIn (t, x)
  for k, v in pairs(t) do
    if v == x then return false end
  end
  return true
end

for _, arr in pairs(nums) do
  i = 0
  repeat
    i = i + 1
  until notIn(arr, i)
  table.insert(missingInts, i)
end

print(table.concat(missingInts, ", "))

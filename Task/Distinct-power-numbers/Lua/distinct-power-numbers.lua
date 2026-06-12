function notIn (t, n)
  for _, v in pairs(t) do
    if v == n then return false end
  end
  return true
end

local distinctPowers, result = {}

for a = 2, 5 do
  for b = 2, 5 do
    result = a ^ b
    if notIn(distinctPowers, result) then
      table.insert(distinctPowers, result)
    end
  end
end

table.sort(distinctPowers)
print(table.concat(distinctPowers, ", "))

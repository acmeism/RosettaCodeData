-- For tables as simple arrays, use the # operator:
fruits = {"apple", "orange"}
print(#fruits)

-- Note the # symbol does not work for non-integer-indexed tables:
fruits = {fruit1 = "apple", fruit2 = "orange"}
print(#fruits)

-- For this you can use this short function:
function size (tab)
  local count = 0
  for k, v in pairs(tab) do
    count = count + 1
  end
  return count
end

print(size(fruits))

function leftShift (t, n)
  local shiftVal
  for i = 1, n do
    shiftVal = table.remove(t, 1)
    table.insert(t, shiftVal)
  end
end

local numTab = {1, 2, 3, 4, 5, 6, 7, 8, 9}
leftShift(numTab, 3)
print(table.concat(numTab, ", "))

function variadicSort (...)
  local t = {}
  for _, x in pairs{...} do
    table.insert(t, x)
  end
  table.sort(t)
  return unpack(t)
end

local testCases = {
  { x = 'lions, tigers, and',
    y = 'bears, oh my!',
    z = '(from the "Wizard of OZ")'
  },
  { x = 77444,
    y = -12,
    z = 0
  }
}
for i, case in ipairs(testCases) do
  x, y, z = variadicSort(case.x, case.y, case.z)
  print("\nCase " .. i)
  print("\tx = " .. x)
  print("\ty = " .. y)
  print("\tz = " .. z)
end

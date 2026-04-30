bc = require("bc")
for i = 2, 9 do
  local d, n, found = bc.new(i), bc.new(0), {}
  local dds = string.rep(d:tostring(), d:tonumber())
  while #found < 10 do
    local dnd = (d * n ^ d):tostring()
    if string.find(dnd, dds) then found[#found+1] = n:tostring() end
    n = n + 1
  end
  print("super-" .. d:tostring() .. ":  " .. table.concat(found,", "))
end

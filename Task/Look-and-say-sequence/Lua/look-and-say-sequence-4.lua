function lookandsay2(t)
  return t:gsub("(1*)(2*)(3*)", function (x, y, z)
    return (x == "" and x or (#x .. x:sub(1, 1))) ..
      (y == "" and y or (#y .. y:sub(1, 1))) ..
      (z == "" and z or (#z .. z:sub(1, 1)))
  end)
end

local t = "1"
for i = 1, 10 do
  print(t)
  t = lookandsay2(t)
end

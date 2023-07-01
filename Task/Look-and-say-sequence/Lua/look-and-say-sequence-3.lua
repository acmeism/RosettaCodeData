function lookandsay(t)
  return t:gsub("(1*)(2*)(3*)", function (...)
    local ret = {}
    for i = 1, select("#", ...) do
      local v = select(i, ...)
      if #v > 0 then
        ret[#ret + 1] = #v
        ret[#ret + 1] = v:sub(1,1)
      end
    end
    return table.concat(ret)
  end)
end

local t = "1"
for i = 1, 10 do
  print(t)
  t = lookandsay(t)
end

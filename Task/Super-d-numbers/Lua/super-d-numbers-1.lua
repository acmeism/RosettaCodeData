for d = 2, 5 do
  local n, found = 0, {}
  local dds = string.rep(d, d)
  while #found < 10 do
    local dnd = string.format("%15.f", d * n ^ d)
    if string.find(dnd, dds) then found[#found+1] = n end
    n = n + 1
  end
  print("super-" .. d .. ":  " .. table.concat(found,", "))
end

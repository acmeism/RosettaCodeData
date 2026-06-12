local untrusted = [[
  print("hello") -- safe
  for i = 1, 7 do print(i, i*i) end -- safe
  setmetatable(_G, malicious) -- unsafe
]]
sandbox = { print=print }
local ret, msg = pcall(load(untrusted,nil,nil,sandbox))
print("ret, msg:", ret, msg)

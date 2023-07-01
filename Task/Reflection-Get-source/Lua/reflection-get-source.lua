debug = require("debug")
function foo(bar)
  info = debug.getinfo(1)
  for k,v in pairs(info) do print(k,v) end
end
foo()

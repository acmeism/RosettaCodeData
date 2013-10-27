function map(f, a)
  local b = {}
  for k,v in ipairs(a) do b[k] = f(v) end
  return b
end

function mapn(f, ...)
  local c = {}
  local k = 1
  local aarg = {...}
  local n = table.getn(aarg)
  while true do
    local a = map(function(b) return b[k] end, aarg)
    if table.getn(a) < n then return c end
    c[k] = f(unpack(a))
    k = k + 1
  end
end

function apply(f1, f2, a)
 return f1(f2, unpack(a))
end

xy = {{1,2,3,4},{1,2,3,4},{1,2,3,4}}
yx = apply(mapn, function(...) return {...} end, xy)
print(table.concat(map(function(a) return table.concat(a,",") end, xy), "\n"),"\n")
print(table.concat(map(function(a) return table.concat(a,",") end, yx), "\n"))

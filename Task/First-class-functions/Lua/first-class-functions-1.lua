function compose(f,g) return function(...) return f(g(...)) end end

fn = {math.sin, math.cos, function(x) return x^3 end}
inv = {math.asin, math.acos, function(x) return x^(1/3) end}

for i, v in ipairs(fn) do
  local f = compose(v, inv[i])
  print(f(0.5))
end

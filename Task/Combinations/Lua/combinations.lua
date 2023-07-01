function map(f, a, ...) if a then return f(a), map(f, ...) end end
function incr(k) return function(a) return k > a and a or a+1 end end
function combs(m, n)
  if m * n == 0 then return {{}} end
  local ret, old = {}, combs(m-1, n-1)
  for i = 1, n do
    for k, v in ipairs(old) do ret[#ret+1] = {i, map(incr(i), unpack(v))} end
  end
  return ret
end

for k, v in ipairs(combs(3, 5)) do print(unpack(v)) end

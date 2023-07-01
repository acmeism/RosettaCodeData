function erato2(n)
  if n < 2 then return {} end
  if n < 3 then return {2} end
  local t = {}
  local lmt = (n - 3) / 2
  local sqrtlmt = (math.sqrt(n) - 3) / 2
  for i = 0, lmt do t[i] = 1 end
  for i = 0, sqrtlmt do if t[i] ~= 0 then
    local p = i + i + 3
    for j = (p*p - 3) / 2, lmt, p do t[j] = 0 end end end
  local primes = {2}
  for i = 0, lmt do if t[i] ~= 0 then table.insert(primes, i + i + 3) end end
  return primes
end

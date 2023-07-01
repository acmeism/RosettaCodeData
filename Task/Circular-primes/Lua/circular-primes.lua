-- Circular primes, in Lua, 6/22/2020 db
local function isprime(n)
  if n < 2 then return false end
  if n % 2 == 0 then return n==2 end
  if n % 3 == 0 then return n==3 end
  for f = 5, math.sqrt(n), 6 do
    if n % f == 0 or n % (f+2) == 0 then return false end
  end
  return true
end

local function iscircularprime(p)
  local n = math.floor(math.log10(p))
  local m, q = 10^n, p
  for i = 0, n do
    if (q < p or not isprime(q)) then return false end
    q = (q % m) * 10 + math.floor(q / m)
  end
  return true
end

local p, dp, list, N = 2, 1, {}, 19
while #list < N do
  if iscircularprime(p) then list[#list+1] = p end
  p, dp = p + dp, 2
end
print(table.concat(list, ", "))

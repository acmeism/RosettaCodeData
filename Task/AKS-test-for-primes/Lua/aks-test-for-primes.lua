-- AKS test for primes, in Lua, 6/23/2020 db
local function coefs(n)
  local list = {[0]=1}
  for k = 0, n do list[k+1] = math.floor(list[k] * (n-k) / (k+1)) end
  for k = 1, n, 2 do list[k] = -list[k] end
  return list
end

local function isprimeaks(n)
  local c = coefs(n)
  c[0], c[n] = c[0]-1, c[n]+1
  for i = 0, n do
    if (c[i] % n ~= 0) then return false end
  end
  return true
end

local function pprintcoefs(n, list)
  local result = ""
  for i = 0, n do
    local s = i==0 and "" or list[i]>=0 and " + " or " - "
    local c, e = math.abs(list[i]), n-i
    if (c==1 and e > 0) then c = "" end
    local x = e==0 and "" or e==1 and "x" or "x^"..e
    result = result .. s .. c .. x
  end
  print("(x-1)^" .. n .." : " .. result)
end

for i = 0, 9 do
  pprintcoefs(i, coefs(i))
end

local primes = {}
for i = 2, 53 do
  if (isprimeaks(i)) then primes[#primes+1] = i end
end
print(table.concat(primes, ", "))

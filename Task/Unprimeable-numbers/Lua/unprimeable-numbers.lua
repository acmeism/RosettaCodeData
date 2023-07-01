-- FUNCS:
local function T(t) return setmetatable(t, {__index=table}) end
table.filter = function(t,f) local s=T{} for _,v in ipairs(t) do if f(v) then s[#s+1]=v end end return s end
table.firstn = function(t,n) local s=T{} n=n>#t and #t or n for i = 1,n do s[i]=t[i] end return s end

-- SIEVE:
local sieve, S = {}, 10000000
for i = 2,S do sieve[i]=true end
for i = 2,S do if sieve[i] then for j=i*i,S,i do sieve[j]=nil end end end

-- UNPRIMABLE:
local unprimables, lowests = T{}, T{}
local floor, log10 = math.floor, math.log10

local function unprimable(n)
  if sieve[n] then return false end
  local nd = floor(log10(n))+1
  for i = 1, nd do
    local pow10 = 10^(nd-i)
    for j = 0, 9 do
      local p = (floor(n/10/pow10) * 10 + j) * pow10 + (n % pow10)
      if sieve[p] then return false end
    end
  end
  return true
end

local n, done = 1, 0
while done < 10 do
  if unprimable(n) then
    unprimables:insert(n)
    if not lowests[n%10] then
      lowests[n%10] = n
      done = done + 1
    end
  end
  n = n + 1
end

-- OUTPUT:
local function commafy(i) return tostring(i):reverse():gsub("(%d%d%d)","%1,"):reverse():gsub("^,","") end
print("The first 35 unprimable numbers are:")
print(unprimables:firstn(35):concat(" "))
print()
print("The 600th unprimable number is:  " .. commafy(unprimables[600]))
print()
print("The lowest unprimable number that ends in..")
for i = 0, 9 do
  print("  " .. i .. " is:  " .. commafy(lowests[i]))
end

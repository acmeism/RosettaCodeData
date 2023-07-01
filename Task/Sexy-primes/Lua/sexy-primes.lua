local N = 1000035

-- FUNCS:
local function T(t) return setmetatable(t, {__index=table}) end
table.filter = function(t,f) local s=T{} for _,v in ipairs(t) do if f(v) then s[#s+1]=v end end return s end
table.map = function(t,f,...) local s=T{} for _,v in ipairs(t) do s[#s+1]=f(v,...) end return s end
table.lastn = function(t,n) local s=T{} n=n>#t and #t or n for i = 1,n do s[i]=t[#t-n+i] end return s end
table.each = function(t,f,...) for _,v in ipairs(t) do f(v,...) end end

-- PRIMES:
local sieve, primes = {false}, T{}
for i = 2,N+6 do sieve[i]=true end
for i = 2,N+6 do if sieve[i] then for j=i*i,N+6,i do sieve[j]=nil end end end
for i = 2,N+6 do if sieve[i] then primes[#primes+1]=i end end

-- TASKS:
local sexy, name = { primes }, { "primes", "pairs", "triplets", "quadruplets", "quintuplets" }
local function sexy2str(v,n) local s=T{} for i=1,n do s[i]=v+(i-1)*6 end return "("..s:concat(" ")..")" end
for i = 2, 5 do
  sexy[i] = sexy[i-1]:filter(function(v) return v+(i-1)*6<N and sieve[v+(i-1)*6] end)
  print(#sexy[i] .. " " .. name[i] .. ", ending with: " .. sexy[i]:lastn(5):map(sexy2str,i):concat(" "))
end
local unsexy = primes:filter(function(v) return not (v>=N or sieve[v-6] or sieve[v+6]) end)
print(#unsexy .. " unsexy, ending with: " ..unsexy:lastn(10):concat(" "))

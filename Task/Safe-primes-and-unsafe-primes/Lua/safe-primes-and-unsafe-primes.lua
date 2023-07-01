-- FUNCS:
local function T(t) return setmetatable(t, {__index=table}) end
table.filter = function(t,f) local s=T{} for _,v in ipairs(t) do if f(v) then s[#s+1]=v end end return s end
table.map = function(t,f,...) local s=T{} for _,v in ipairs(t) do s[#s+1]=f(v,...) end return s end
table.firstn = function(t,n) local s=T{} n=n>#t and #t or n for i = 1,n do s[i]=t[i] end return s end

-- SIEVE:
local sieve, safe, unsafe, floor, N = {}, T{}, T{}, math.floor, 10000000
for i = 2,N do sieve[i]=true end
for i = 2,N do if sieve[i] then for j=i*i,N,i do sieve[j]=nil end end end
for i = 2,N do if sieve[i] then local t=sieve[floor((i-1)/2)] and safe or unsafe t[#t+1]=i end end

-- TASKS:
local function commafy(i) return tostring(i):reverse():gsub("(%d%d%d)","%1,"):reverse():gsub("^,","") end
print("First 35 safe primes        :  " .. safe:firstn(35):map(commafy):concat(" "))
print("# safe primes < 1,000,000   :  " .. commafy(#safe:filter(function(v) return v<1e6 end)))
print("# safe primes < 10,000,000  :  " .. commafy(#safe))
print("First 40 unsafe primes      :  " .. unsafe:firstn(40):map(commafy):concat(" "))
print("# unsafe primes < 1,000,000 :  " .. commafy(#unsafe:filter(function(v) return v<1e6 end)))
print("# unsafe primes < 10,000,000:  " .. commafy(#unsafe))

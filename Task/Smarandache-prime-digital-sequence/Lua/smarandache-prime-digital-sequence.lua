-- FUNCS:
local function T(t) return setmetatable(t, {__index=table}) end
table.firstn = function(t,n) local s=T{} n=n>#t and #t or n for i = 1,n do s[i]=t[i] end return s end

-- SIEVE:
local sieve, S = {}, 50000
for i = 2,S do sieve[i]=true end
for i = 2,S do if sieve[i] then for j=i*i,S,i do sieve[j]=nil end end end

-- TASKS:
local digs, cans, spds, N = {2,3,5,7}, T{0}, T{}, 100
while #spds < N do
  local c = cans:remove(1)
  for _,d in ipairs(digs) do cans:insert(c*10+d) end
  if sieve[c] then spds:insert(c) end
end
print("1-25 :  " .. spds:firstn(25):concat(" "))
print("100th:  " .. spds[100])

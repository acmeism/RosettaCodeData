local function isprime(n)
  if n < 2 then return false end
  if n % 2 == 0 then return n==2 end
  if n % 3 == 0 then return n==3 end
  local f, limit = 5, math.sqrt(n)
  for f = 5, limit, 6 do
    if n % f == 0 then return false end
    if n % (f+2) == 0 then return false end
  end
  return true
end

local function s3iter()
  local s, i2, i3 = {1}, 1, 1
  return function()
    local n2, n3, val = 2*s[i2], 3*s[i3], s[#s]
    s[#s+1] = math.min(n2, n3)
    i2, i3 = i2 + (n2<=n3 and 1 or 0), i3 + (n2>=n3 and 1 or 0)
    return val
  end
end

local function pierpont(n)
  local list1, list2, s3next = {}, {}, s3iter()
  while #list1 < n or #list2 < n do
    local s3 = s3next()
    if #list1 < n then
      if isprime(s3+1) then list1[#list1+1] = s3+1 end
    end
    if #list2 < n then
      if isprime(s3-1) then list2[#list2+1] = s3-1 end
    end
  end
  return list1, list2
end

local N = 50
local p1, p2 = pierpont(N)

print("First 50 Pierpont primes of the first kind:")
for i, p in ipairs(p1) do
  io.write(string.format("%8d%s", p, (i%10==0 and "\n" or " ")))
end

print()

print("First 50 Pierpont primes of the second kind:")
for i, p in ipairs(p2) do
  io.write(string.format("%8d%s", p, (i%10==0 and "\n" or " ")))
end

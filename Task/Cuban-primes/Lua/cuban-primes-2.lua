-- cuban primes in Lua (alternate version 6/12/2020 db)
------------------
-- PRIME SUPPORT:
------------------
local sqrt, sieve, primes, N = math.sqrt, {false}, {}, 1400000
for i = 2,N do sieve[i]=true end
for i = 2,N do if sieve[i] then for j=i*i,N,i do sieve[j]=false end end end
for i = 2,N do if sieve[i] then primes[#primes+1]=i end end; sieve=nil
local function isprime(n)
  if (n <= 1) then return false end
  local limit = sqrt(n)
  for i,p in ipairs(primes) do
    if (n % p == 0) then return false end
    if (p > limit) then return true end
  end
  error("insufficient list of primes")
end

------------------
-- PRINT SUPPORT:
------------------
local write, format = io.write, string.format
local function commafy(i) return tostring(i):reverse():gsub("(%d%d%d)","%1,"):reverse():gsub("^,","") end

----------------
-- ACTUAL TASK:
----------------
local COUNT, DOTAT, DOTPER, count, n = 100000, 200, 2000, 0, 0
while (count < COUNT) do
  local h = 3 * n * (n + 1) + 1 -- A003215
  if (isprime(h)) then
    count = count + 1
    if (count <= DOTAT) then
      write(format("%11s%s", commafy(h), count%10==0 and "\n" or ""))
    elseif (count == COUNT) then
      print(format("\n%s", commafy(h)))
    elseif (count % DOTPER == 0) then
      write(".")
    end
  end
  n = n + 1
end

local function is_prime(n)
  if n < 2 then return false end
  if n % 2 == 0 then return n==2 end
  if n % 3 == 0 then return n==3 end
  for f = 5, n^0.5, 6 do
    if n%f==0 or n%(f+2)==0 then return false end
  end
  return true
end

local function descending_primes()
  local digits, candidates, primes = {9,8,7,6,5,4,3,2,1}, {0}, {}
  for i = 1, #digits do
    for j = 1, #candidates do
      local value = candidates[j] * 10 + digits[i]
      if is_prime(value) then primes[#primes+1] = value end
      candidates[#candidates+1] = value
    end
  end
  table.sort(primes)
  return primes
end

print(table.concat(descending_primes(), ", "))

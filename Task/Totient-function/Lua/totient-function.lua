-- Return the greatest common denominator of x and y
function gcd (x, y)
  return y == 0 and math.abs(x) or gcd(y, x % y)
end

-- Return the totient number for n
function totient (n)
  local count = 0
  for k = 1, n do
    if gcd(n, k) == 1 then count = count + 1 end
  end
  return count
end

-- Determine (inefficiently) whether p is prime
function isPrime (p)
  return totient(p) == p - 1
end

-- Output totient and primality for the first 25 integers
print("n", string.char(237), "prime")
print(string.rep("-", 21))
for i = 1, 25 do
  print(i, totient(i), isPrime(i))
end

-- Count the primes up to 100, 1000 and 10000
local pCount, i, limit = 0, 1
for power = 2, 4 do
  limit = 10 ^ power
  repeat
    i = i + 1
    if isPrime(i) then pCount = pCount + 1 end
  until i == limit
  print("\nThere are " .. pCount .. " primes below " .. limit)
end

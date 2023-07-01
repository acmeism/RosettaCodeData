-- Return a table of the primes up to n, then one more
function primeList (n)
  local function isPrime (x)
    for d = 3, math.sqrt(x), 2 do
      if x % d == 0 then return false end
    end
    return true
  end
  local pTable, j = {2, 3}
  for i = 5, n, 2 do
    if isPrime(i) then
      table.insert(pTable, i)
    end
    j = i
  end
  repeat j = j + 2 until isPrime(j)
  table.insert(pTable, j)
  return pTable
end

-- Return a boolean indicating whether prime p is strong
function isStrong (p)
  if p == 1 or p == #prime then return false end
  return prime[p] > (prime[p-1] + prime[p+1]) / 2
end

-- Return a boolean indicating whether prime p is weak
function isWeak (p)
  if p == 1 or p == #prime then return false end
  return prime[p] < (prime[p-1] + prime[p+1]) / 2
end

-- Main procedure
prime = primeList(1e7)
local strong, weak, sCount, wCount = {}, {}, 0, 0
for k, v in pairs(prime) do
  if isStrong(k) then
    table.insert(strong, v)
    if v < 1e6 then sCount = sCount + 1 end
  end
  if isWeak(k) then
    table.insert(weak, v)
    if v < 1e6 then wCount = wCount + 1 end
  end
end
print("The first 36 strong primes are:")
for i = 1, 36 do io.write(strong[i] .. " ") end
print("\n\nThere are " .. sCount .. " strong primes below one million.")
print("\nThere are " .. #strong .. " strong primes below ten million.")
print("\nThe first 37 weak primes are:")
for i = 1, 37 do io.write(weak[i] .. " ") end
print("\n\nThere are " .. wCount .. " weak primes below one million.")
print("\nThere are " .. #weak .. " weak primes below ten million.")

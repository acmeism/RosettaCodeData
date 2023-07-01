-- Returns true if x is prime, and false otherwise
function isPrime (x)
  if x < 2 then return false end
  if x < 4 then return true end
  if x % 2 == 0 then return false end
  for d = 3, math.sqrt(x), 2 do
    if x % d == 0 then return false end
  end
  return true
end

-- Compute the prime factors of n
function factors (n)
  local facList, divisor, count = {}, 1
  if n < 2 then return facList end
  while not isPrime(n) do
    while not isPrime(divisor) do divisor = divisor + 1 end
    count = 0
    while n % divisor == 0 do
      n = n / divisor
      table.insert(facList, divisor)
    end
    divisor = divisor + 1
    if n == 1 then return facList end
  end
  table.insert(facList, n)
  return facList
end

-- Main procedure
for i = 1, 120 do
  if isPrime(#factors(i)) then io.write(i .. "\t") end
end

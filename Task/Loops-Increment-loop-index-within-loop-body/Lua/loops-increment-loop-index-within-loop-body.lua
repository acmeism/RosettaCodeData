-- Returns boolean indicate whether x is prime
function isPrime (x)
  if x < 2 then return false end
  if x < 4 then return true end
  if x % 2 == 0 then return false end
  for d = 3, math.sqrt(x), 2 do
    if x % d == 0 then return false end
  end
  return true
end

-- Main procedure
local n, i = 0, 42
while n < 42 do
  if isPrime(i) then
    n = n + 1
    print("n = " .. n, i)
    i = 2 * i - 1
  end
  i = i + 1
end

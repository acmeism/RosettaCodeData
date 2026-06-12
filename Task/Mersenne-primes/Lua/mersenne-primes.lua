-- Returns a boolean to show whether x is prime
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
local i, p = 0
repeat
  i = i + 1
  p = 2 ^ i - 1
  if isPrime(p) then
    print("2 ^ " .. i .. " - 1 = " .. p)
  end
until p == p + 1

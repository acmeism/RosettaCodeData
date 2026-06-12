 function MRIsPrime(n, k)
  -- If n is prime, returns true (without fail).
  -- If n is not prime, then returns false with probability ≥ 4^(-k), true otherwise.
  -- First, deal with 1 and multiples of 2.
  if n == 1 then
    return false
  elseif n == 2 then
    return true
  elseif n%2 == 0 then
    return false
  end
  -- Now n is odd and greater than 1.
  -- Find the unique expression n = 1 + t*2^h for n, where t is odd and h≥1.
  t = (n-1)/2
  h = 1
  while t%2 == 0 do
    t = t/2
    h = h + 1
  end
  for i = 1, k do
    -- Generate a random integer between 1 and n-1 inclusive.
    a = math.random(n-1)
    -- Test whether a is an element of the set L, and return false if not.
    if not IsInL(n, a, t, h) then
      return false
    end
  end
  -- All generated a were in the set L; thus with high probability, n is prime.
  return true
end

function IsInL(n, a, t, h)
  local b = PowerMod(a, t, n)
  if b == 1 then
    return true
  end
  for j = 0, h-1 do
    if b == n-1 then
      return true
    elseif b == 1 then
      return false
    end
    b = (b^2)%n
  end
  return false
end

function PowerMod(x, y, m)
  -- Computes x^y mod m.
  local z = 1
  while y > 0 do
    if y%2 == 0 then
      x, y, z = (x^2)%m, y//2, z
    else
      x, y, z = (x^2)%m, y//2, (x*z)%m
    end
  end
  return z
end

loop i = 0 to 15
    say "catI("i") =" .catalan~catI(i)
    say "catR1("i") =" .catalan~catR1(i)
    say "catR2("i") =" .catalan~catR2(i)
end

-- This is implemented as static members on a class object
-- so that the code is able to keep state information between calls.  This
-- memoization will speed up things like factorial calls by remembering previous
-- results.
::class catalan
-- initialize the class object
::method init class
  expose facts catI catR1 catR2
         facts = .table~new
         catI = .table~new
         catR1 = .table~new
         catR2 = .table~new
         -- seed a few items
         facts[0] = 1
         facts[1] = 1
         facts[2] = 2
         catI[0] = 1
         catR1[0] = 1
         catR2[0] = 1

-- private factorial method
::method fact private class
  expose facts
  use arg n
  -- see if we've calculated this before
  if facts~hasIndex(n) then return facts[n]
  numeric digits 120

  fact = 1
  loop i = 2 to n
      fact *= i
  end
  -- save this result
  facts[n] = fact
  return fact

::method catI class
  expose catI
  use arg n
  numeric digits 20

  res = catI[n]
  if res == .nil then do
      -- dividing by 1 removes insignificant trailing 0s
      res = (self~fact(2 * n)/(self~fact(n + 1) * self~fact(n))) / 1
      catI[n] = res
  end
  return res

::method catR1 class
  expose catR1
  use arg n
  numeric digits 20

  if catR1~hasIndex(n) then return catR1[n]
  sum = 0
  loop i = 0 to n - 1
      sum += self~catR1(i) * self~catR1(n - 1 - i)
  end
  -- remove insignificant trailing 0s
  sum = sum / 1
  catR1[n] = sum
  return sum

::method catR2 class
  expose catR2
  use arg n
  numeric digits 20

  res = catR2[n]
  if res == .nil then do
     res = ((2 * (2 * n - 1) * self~catR2(n - 1)) /  (n + 1))
     catR2[n] = res
  end
  return res

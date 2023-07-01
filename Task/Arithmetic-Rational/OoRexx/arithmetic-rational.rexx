loop candidate = 6 to 2**19
    sum = .fraction~new(1, candidate)
    max2 = rxcalcsqrt(candidate)~trunc

    loop factor = 2 to max2
        if candidate // factor == 0 then do
           sum += .fraction~new(1, factor)
           sum += .fraction~new(1, candidate / factor)
        end
    end
    if sum == 1 then say candidate "is a perfect number"
end

::class fraction public inherit orderable
::method init
  expose numerator denominator
  use strict arg numerator, denominator = 1

  if denominator == 0 then raise syntax 98.900 array("Fraction denominator cannot be zero")

  -- if the denominator is negative, make the numerator carry the sign
  if denominator < 0 then do
      numerator = -numerator
      denominator = - denominator
  end


  -- find the greatest common denominator and reduce to
  -- the simplest form
  gcd = self~gcd(numerator~abs, denominator~abs)

  numerator /= gcd
  denominator /= gcd

-- fraction instances are immutable, so these are
-- read only attributes
::attribute numerator GET
::attribute denominator GET

-- calculate the greatest common denominator of a numerator/denominator pair
::method gcd private
  use arg x, y

  loop while y \= 0
      -- check if they divide evenly
      temp = x // y
      x = y
      y = temp
  end
  return x

-- calculate the least common multiple of a numerator/denominator pair
::method lcm private
  use arg x, y
  return x / self~gcd(x, y) * y

::method abs
  expose numerator denominator
  -- the denominator is always forced to be positive
  return self~class~new(numerator~abs, denominator)

::method reciprocal
  expose numerator denominator
  return self~class~new(denominator, numerator)

-- convert a fraction to regular Rexx number
::method toNumber
  expose numerator denominator

  if numerator == 0 then return 0
  return numerator/denominator

::method negative
  expose numerator denominator
  return self~class~new(-numerator, denominator)

::method add
  expose numerator denominator
  use strict arg other
  -- convert to a fraction if a regular number
  if \other~isa(.fraction) then other = self~class~new(other, 1)

  multiple = self~lcm(denominator, other~denominator)
  newa = numerator * multiple / denominator
  newb = other~numerator * multiple / other~denominator
  return self~class~new(newa + newb, multiple)

::method subtract
  use strict arg other
  return self + (-other)

::method times
  expose numerator denominator
  use strict arg other
  -- convert to a fraction if a regular number
  if \other~isa(.fraction) then other = self~class~new(other, 1)
  return self~class~new(numerator * other~numerator, denominator * other~denominator)

::method divide
  use strict arg other
  -- convert to a fraction if a regular number
  if \other~isa(.fraction) then other = self~class~new(other, 1)
  -- and multiply by the reciprocal
  return self * other~reciprocal

-- compareTo method used by the orderable interface to implement
-- the operator methods
::method compareTo
  expose numerator denominator
  -- convert to a fraction if a regular number
  if \other~isa(.fraction) then other = self~class~new(other, 1)

  return (numerator * other~denominator - denominator * other~numerator)~sign

-- we still override "==" and "\==" because we want to bypass the
-- checks for not being an instance of the class
::method "=="
  expose numerator denominator
  use strict arg other

  -- convert to a fraction if a regular number
  if \other~isa(.fraction) then other = self~class~new(other, 1)
  -- Note:  these are numeric comparisons, so we're using the "="
  -- method so those are handled correctly
  return numerator = other~numerator & denominator = other~denominator

::method "\=="
  use strict arg other
  return \self~"\=="(other)

-- some operator overrides -- these only work if the left-hand-side of the
-- subexpression is a quaternion
::method "*"
  forward message("TIMES")

::method "/"
  forward message("DIVIDE")

::method "-"
  -- need to check if this is a prefix minus or a subtract
  if arg() == 0 then
      forward message("NEGATIVE")
  else
      forward message("SUBTRACT")

::method "+"
  -- need to check if this is a prefix plus or an addition
  if arg() == 0 then
      return self  -- we can return this copy since it is imutable
  else
      forward message("ADD")

::method string
  expose numerator denominator
  if denominator == 1 then return numerator
  return numerator"/"denominator

-- override hashcode for collection class hash uses
::method hashCode
  expose numerator denominator
  return numerator~hashcode~bitxor(numerator~hashcode)

::requires rxmath library

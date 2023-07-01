q = .quaternion~new(1, 2, 3, 4)
q1 = .quaternion~new(2, 3, 4, 5)
q2 = .quaternion~new(3, 4, 5, 6)
r = 7

say "q            =" q
say "q1           =" q1
say "q2           =" q2
say "r            =" r
say "norm(q)      =" q~norm
say "-q           =" (-q)
say "q*           =" q~conjugate
say "q + r        =" q + r
say "q1 + q2      =" q1 + q2
say "q * r        =" q * r
q1q2 = q1 * q2
q2q1 = q2 * q1
say "q1 * q2      =" q1q2
say "q2 * q1      =" q2q1
say "q1 == q1     =" (q1 == q1)
say "q1q2 == q2q1 =" (q1q2 == q2q1)


::class quaternion
::method init
  expose r i j k
  use strict arg r, i = 0, j = 0, k = 0

-- quaternion instances are immutable, so these are
-- read only attributes
::attribute r GET
::attribute i GET
::attribute j GET
::attribute k GET

::method norm
  expose r i j k
  return rxcalcsqrt(r * r + i * i + j * j + k * k)

::method invert
  expose r i j k
  norm = self~norm
  return self~class~new(r / norm, i / norm, j / norm, k / norm)

::method negative
  expose r i j k
  return self~class~new(-r, -i, -j, -k)

::method conjugate
  expose r i j k
  return self~class~new(r, -i, -j, -k)

::method add
  expose r i j k
  use strict arg other
  if other~isa(.quaternion) then
     return self~class~new(r + other~r, i + other~i, j + other~j, k + other~k)
  else return self~class~new(r + other, i, j, k)

::method subtract
  expose r i j k
  use strict arg other
  if other~isa(.quaternion) then
     return self~class~new(r - other~r, i - other~i, j - other~j, k - other~k)
  else return self~class~new(r - other, i, j, k)

::method times
  expose r i j k
  use strict arg other
  if other~isa(.quaternion) then
     return self~class~new(r * other~r - i * other~i - j * other~j - k * other~k, -
                           r * other~i + i * other~r + j * other~k - k * other~j, -
                           r * other~j - i * other~k + j * other~r + k * other~i, -
                           r * other~k + i * other~j - j * other~i + k * other~r)
  else return self~class~new(r * other, i * other, j * other, k * other)

::method divide
  use strict arg other
  -- this is easier if everything is a quaternion
  if \other~isA(.quaternion) then other = .quaternion~new(other)
  -- division is multiplication with the inversion
  return self * other~invert

::method "=="
  expose r i j k
  use strict arg other

  if \other~isa(.quaternion) then return .false
  -- Note:  these are numeric comparisons, so we're using the "="
  -- method so those are handled correctly
  return r = other~r & i = other~i & j = other~j & k = other~k

::method "\=="
  use strict arg other
  return \self~"\=="(other)

::method "="
  -- this is equivalent of "=="
  forward message("==")

::method "\="
  -- this is equivalent of "\=="
  forward message("\==")

::method "<>"
  -- this is equivalent of "\=="
  forward message("\==")

::method "><"
  -- this is equivalent of "\=="
  forward message("\==")

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
      return self  -- we can return this copy since it is immutable
  else
      forward message("ADD")

::method string
  expose r i j k
  return r self~formatnumber(i)"i" self~formatnumber(j)"j" self~formatnumber(k)"k"

::method formatnumber private
  use arg value
  if value > 0 then return "+" value
  else return "-" value~abs

-- override hashcode for collection class hash uses
::method hashCode
  expose r i j k
  return r~hashcode~bitxor(i~hashcode)~bitxor(j~hashcode)~bitxor(k~hashcode)


::requires rxmath LIBRARY

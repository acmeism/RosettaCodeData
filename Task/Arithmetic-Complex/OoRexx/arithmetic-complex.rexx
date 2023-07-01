c1 = .complex~new(1, 2)
c2 = .complex~new(3, 4)
r = 7

say "c1           =" c1
say "c2           =" c2
say "r            =" r
say "-c1          =" (-c1)
say "c1 + r       =" c1 + r
say "c1 + c2      =" c1 + c2
say "c1 - r       =" c1 - r
say "c1 - c2      =" c1 - c2
say "c1 * r       =" c1 * r
say "c1 * c2      =" c1 * c2
say "inv(c1)      =" c1~inv
say "conj(c1)     =" c1~conjugate
say "c1 / r       =" c1 / r
say "c1 / c2      =" c1 / c2
say "c1 == c1     =" (c1 == c1)
say "c1 == c2     =" (c1 == c2)


::class complex
::method init
  expose r i
  use strict arg r, i = 0

-- complex instances are immutable, so these are
-- read only attributes
::attribute r GET
::attribute i GET

::method negative
  expose r i
  return self~class~new(-r, -i)

::method add
  expose r i
  use strict arg other
  if other~isa(.complex) then
     return self~class~new(r + other~r, i + other~i)
  else return self~class~new(r + other, i)

::method subtract
  expose r i
  use strict arg other
  if other~isa(.complex) then
     return self~class~new(r - other~r, i - other~i)
  else return self~class~new(r - other, i)

::method times
  expose r i
  use strict arg other
  if other~isa(.complex) then
     return self~class~new(r * other~r - i * other~i, r * other~i + i * other~r)
  else return self~class~new(r * other, i * other)

::method inv
  expose r i
  denom = r * r + i * i
  return self~class~new(r/denom,-i/denom)

::method conjugate
  expose r i
  return self~class~new(r, -i)

::method divide
  use strict arg other
  -- this is easier if everything is a complex number
  if \other~isA(.complex) then other = .complex~new(other)
  -- division is multiplication with the inversion
  return self * other~inv

::method "=="
  expose r i
  use strict arg other

  if \other~isa(.complex) then return .false
  -- Note:  these are numeric comparisons, so we're using the "="
  -- method so those are handled correctly
  return r = other~r & i = other~i

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
  expose r i
  return r self~formatnumber(i)"i"

::method formatnumber private
  use arg value
  if value > 0 then return "+" value
  else return "-" value~abs

-- override hashcode for collection class hash uses
::method hashCode
  expose r i
  return r~hashcode~bitxor(i~hashcode)

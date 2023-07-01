Numeric Digits 50
Call test '9 4 6 6'
Call test '5 10 6 7'
Exit

test:
Parse Arg w1 s1 w2 s2
p1.=.fraction~new(0,1)
p2.=.fraction~new(0,1)
Call pp 1,w1,s1,p1.,p2.
Call pp 2,w2,s2,p1.,p2.
p2low.=.fraction~new(0,1)
Do x=w1 To w1*s1
  Do y=0 To x-1
    p2low.x=p2low.x+p2.y
    End
  End
pwin1=.fraction~new(0,1)
Do x=w1 To w1*s1
  pwin1=pwin1+(p1.x*p2low.x)
  End
Say 'Player 1 has' w1 'dice with' s1 'sides each'
Say 'Player 2 has' w2 'dice with' s2 'sides each'
Say 'Probability for player 1 to win:' pwin1~string
Say '                              ->' pwin1~tonumber
Say ''
Return

pp: Procedure
/*---------------------------------------------------------------------
* Compute and assign probabilities to get a sum x
* when throwing w dice each having s sides (marked from 1 to s)
* k=1 sets p1.*, k=2 sets p2.*
*--------------------------------------------------------------------*/
Use Arg k,w,s,p1.,p2.
str=''
cnt.=0
Do wi=1 To w
  str=str||'Do v'wi'=1 To' s';'
  End
str=str||'sum='
Do wi=1 To w-1
  str=str||'v'wi'+'
  End
str=str||'v'w';'
str=str||'cnt.sum+=1;'
Do wi=1 To w
  str=str||'End;'
  End
Interpret str

psum=.fraction~new(0,1)
Do x=0 To w*s
  If k=1 Then
    p1.x=.fraction~new(cnt.x,s**w)
  Else
    p2.x=.fraction~new(cnt.x,s**w)
  psum=psum+p1.x
  End
Return

::class fraction inherit orderable
::options Digits 50
::method init
  expose numerator denominator
  use strict arg numerator, denominator = 1
  --Trace ?R
  --if numerator == 0 then denominator = 0
  --else if denominator == 0 then raise syntax 98.900 array("Fraction denominator cannot be zero")

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

-- calculate the greatest common denominator of a numerator/denominator pair
::method gcd private
  use arg x, y
  --Say 'gcd:' x y digits()
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

-- convert a fraction to regular Rexx number
::method toNumber
  expose numerator denominator
  if numerator == 0 then return 0
  return numerator/denominator

::method add
  expose numerator denominator
  use strict arg other
  -- convert to a fraction if a regular number
  if \other~isa(.fraction) then other = self~class~new(other, 1)

  multiple = self~lcm(denominator, other~denominator)
  newa = numerator * multiple / denominator
  newb = other~numerator * multiple / other~denominator
  return self~class~new(newa + newb, multiple)

::method times
  expose numerator denominator
  use strict arg other
  -- convert to a fraction if a regular number
  if \other~isa(.fraction) then other = self~class~new(other, 1)
  return self~class~new(numerator * other~numerator, denominator * other~denominator)

-- some operator overrides -- these only work if the left-hand-side of the
-- subexpression is a quaternion
::method "*"
  forward message("TIMES")

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

::attribute numerator GET
::attribute denominator GET

::requires rxmath library

Numeric Digits 16
list='1 1 1 1 0 0 0 0'
n=words(list)
x=.array~new(n)
Do i=1 To n
  x[i]=.complex~new(word(list,i),0)
  End
Call show 'FFT  in',x
call fft x
Call show 'FFT out',x
Exit

show: Procedure
  Use Arg data,x
  Say '---data---   num       real-part   imaginary-part'
  Say '----------   ---       ---------   --------------'
  Do i=1 To x~size
    say data right(i,7)'       ' x[i]~string
    End
  Return

fft: Procedure
  Use Arg in
  Numeric Digits 16
  n=in~size
  If n=1 Then Return
  odd=.array~new(n/2)
  even=.array~new(n/2)
  Do j=1 To n By 2; odd[(j+1)/2]=in[j]; End
  Do j=2 To n By 2; even[j/2]=in[j]; End
  Call fft odd
  Call fft even
  pi=3.14159265358979323E0
  n_2=n/2
  Do i=1 To n_2
    w=-2*pi*(i-1)/N
    t=.complex~new(rxCalcCos(w,,'R'),rxCalcSin(w,,'R'))*even[i]
    in[i]=odd[i]+t
    in[i+n_2]=odd[i]-t
    End
  Return

::class complex
::method init
  expose r i
  use strict arg r, i = 0

-- complex instances are immutable, so these are
-- read only attributes
::attribute r GET
::attribute i GET

::method add
  expose r i
  Numeric Digits 16
  use strict arg other
  if other~isa(.complex) then
     return self~class~new(r + other~r, i + other~i)
  else return self~class~new(r + other, i)

::method subtract
  expose r i
  Numeric Digits 16
  use strict arg other
  if other~isa(.complex) then
     return self~class~new(r - other~r, i - other~i)
  else return self~class~new(r - other, i)

::method "+"
  Numeric Digits 16
  -- need to check if this is a prefix plus or an addition
  if arg() == 0 then
      return self  -- we can return this copy since it is immutable
  else
      forward message("ADD")

::method "-"
  Numeric Digits 16
  -- need to check if this is a prefix minus or a subtract
  if arg() == 0 then
      forward message("NEGATIVE")
  else
      forward message("SUBTRACT")

::method times
  expose r i
  Numeric Digits 16
  use strict arg other
  if other~isa(.complex) then
     return self~class~new(r * other~r - i * other~i, r * other~i + i * other~r)
  else return self~class~new(r * other, i * other)

::method "*"
  Numeric Digits 16
  forward message("TIMES")

::method string
  expose r i
  Numeric Digits 12
  Select
    When i=0 Then
      If r=0 Then
        Return '0'
      Else
        Return format(r,1,9)
    When i>0 Then
      Return format(r,1,9)' +'format(i,1,9)'i'
    Otherwise
      Return format(r,1,9)' -'format(abs(i),1,9)'i'
    End

::method formatnumber private
  use arg value
  Numeric Digits 16
  if value > 0 then return "+" value
  else return "-" value~abs

::requires rxMath library

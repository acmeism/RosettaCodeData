arg n; if n = '' then n = 100; numeric digits n
parse version version; say version; glob. = ''
say 'Euler-Mascheroni constant to' n 'decimal places'
say 'Method Brent-McMillan'
say
call time('r'); a = Brent(); e = format(time('e'),,3)
say 'Brent     ' a '('e 'seconds)'
call time('r'); a = TrueValue(); e = format(time('e'),,3)
say 'True value' a '('e 'seconds)'
exit

Brent:
procedure expose glob.
numeric digits Digits()+2
-- Brent McMillan
n = Ceil((Digits()*Ln(10)+Ln(Pi()))*0.25); m = Ceil(2.07*Digits())
n2 = n*n; ak = -Ln(n); bk = 1; s = ak; v = 1
do k = 1 to m
   bk = bk*n2/(k*k); ak = (ak*n2/k+bk)/k
   s = s+ak; v = v+bk
end
y = s/v
numeric digits Digits()-2
return y+0

TrueValue:
procedure expose glob.
return 0.5772156649015328606065120900824024310421593359399235988057672348848677267776646709369470632917467495+0

E:
-- Euler number
procedure expose glob.
p = Digits()
-- In memory?
if glob.e.p <> '' then
   return glob.e.p
if p < 101 then
-- Fast value
   glob.e.p = 2.71828182845904523536028747135266249775724709369995957496696762772407663035354759457138217852516643+0
else do
   numeric digits Digits()+2
-- Taylor
   y = 2; t = 1; v = y
   do n = 2
      t = t/n; y = y+t
      if y = v then
         leave
      v = y
   end
   numeric digits Digits()-2
   glob.e.p = y+0
end
return glob.e.p

Fact:
-- Factorial n!
procedure expose glob.
arg x
-- Validity
if \ Whole(x) then
   return 'X'
if x < 0 then
   return 'X'
-- Current in memory?
if glob.fact.x <> '' then
   return glob.fact.x
w = x-1
-- Previous in memory?
if glob.fact.w = '' then do
-- Loop cf definition
   y = 1
   do n = 2 to x
      y = y*n
   end
   glob.fact.x = y
end
else
-- Multiply
   glob.fact.x = glob.fact.w*x
return glob.fact.x

Ln2:
-- Natural log of 2 constant
procedure expose glob.
-- Fast value
y = 0.6931471805599453094172321214581765680755001343602552541206800094933936219696947156058633269964186875
return y+0

Ln4:
-- Natural log of 4 constant
procedure expose glob.
-- Fast value
y = 1.386294361119890618834464242916353136151000268720510508241360018986787243939389431211726653992837375
return y+0

Ln8:
-- Natural log of 8 constant
procedure expose glob.
-- Fast value
y = 2.079441541679835928251696364374529704226500403080765762362040028480180865909084146817589980989256063
return y+0

Ln10:
-- Natural log of 10 constant
procedure expose glob.
-- Fast value
y = 2.30258509299404568401799145468436420760110148862877297603332790096757260967735248023599720508959830
return y+0

Pi:
-- Pi constant
procedure expose glob.
p = Digits()
-- In memory?
if glob.pi.p <> '' then
   return glob.pi.p
if p < 101 then
-- Fast value
   glob.pi.p = 3.14159265358979323846264338327950288419716939937510582097494459230781640628620899862803482534211707+0
else do
   numeric digits Digits()+2
   if p < 201 then do
-- Chudnovsky
      y = 0
      do n = 0
         v = y; y = y + Fact(6*n)*(13591409+545140134*n)/(Fact(3*n)*Fact(n)**3*-640320**(3*n))
         if y = v then
            leave
      end
      y = 4270934400/(Sqrt(10005)*y)
   end
   else do
-- Agmean
      y = 0.25; a = 1; g = Sqrt(0.5); n = 1
      do until a = v
         v = a
         x = (a+g)*0.5; g = Sqrt(a*g)
         y = y-n*(x-a)**2; n = n+n; a = x
      end
      y = a*a/y
   end
   numeric digits Digits()-2
   glob.pi.p = y+0
end
return glob.pi.p

Ceil:
-- Ceiling
procedure expose glob.
arg x
-- Formulas
if Whole(x) then
   return x
else
   return Trunc(x)+(x>=0)

Ln:
-- Natural logarithm base e
procedure expose glob.
arg x
-- Validity
if x <= 0 then
   return 'X'
-- Fast values
if x = 1 then
   return 0
p = Digits()
-- In memory?
if glob.ln.x.p <> '' then
   return glob.ln.x.p
-- Precalculated values
if x = 2 & p < 101 then do
   glob.ln.x.p = Ln2()
   return glob.ln.x.p
end
if x = 4 & p < 101 then do
   glob.ln.x.p = Ln4()
   return glob.ln.x.p
end
if x = 8 & p < 101 then do
   glob.ln.x.p = Ln8()
   return glob.ln.x.p
end
if x = 10 & p < 101 then do
   glob.ln.x.p = Ln10()
   return glob.ln.x.p
end
numeric digits p+2
-- Argument reduction
z = x; i = 0; e = 1/E()
if z < 0.5 then do
   y = 1/z
   do while y > 1.5
      y = y*e; i = i-1
   end
   z = 1/y
end
if z > 1.5 then do
   do while z > 1.5
      z = z*e; i = i+1
   end
end
-- Taylor series
q = (z-1)/(z+1); f = q; y = q; v = q; q = q*q
do n = 3 by 2
   f = f*q; y = y+f/n
   if y = v then
      leave
   v = y
end
numeric digits p
-- Inverse reduction
glob.ln.x.p = 2*y+i
return glob.ln.x.p

Sqrt:
-- Square root x^(1/2)
procedure expose glob.
arg x
-- Validity
if x < 0 then
   return 'X'
-- Fast values
if x = 0 then
   return 0
if x = 1 then
   return 1
p = Digits()
-- Predefined values
if x = 2 & p < 101 then
   return Sqrt2()
if x = 3 & p < 101 then
   return Sqrt3()
if x = 5 & p < 101 then
   return Sqrt5()
numeric digits p+2
-- Argument reduction to [0,100)
i = Xpon(x); i = (i-(i<0))%2; x = x/100**i
-- First guess 1 digit accurate
t = '2.5 6.5 12.5 20.5 30.5 42.5 56.5 72.5 90.5 100'
do y = 1 until word(t,y) > x
end
-- Dynamic precision
d = Digits()
do n = 1 while d > 2
   d.n = d; d = d%2+1
end
d.n = 2
-- Method Heron
do k = n to 1 by -1
   numeric digits d.k
   y = (y+x/y)*0.5
end
numeric digits p
return y*10**i

Whole:
-- Is a number integer?
procedure expose glob.
arg x
-- Formula
return Datatype(x,'w')

Xpon:
-- Exponent
procedure expose glob.
arg x
-- Formula
if x = 0 then
   return 0
else
   return Right(x*1E+99999,6)-99999

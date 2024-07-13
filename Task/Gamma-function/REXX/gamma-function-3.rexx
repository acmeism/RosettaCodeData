parse version version; say version; glob. = ''
say 'Gamma function in arbitrary precision'
say
say '(Half)integers formulas'
w = '-99.5 -10.5 -5.5 -2.5 -1.5 -0.5 0.5 1 1.5 2 2.5 5 5.5 10 10.5 99 99.5'
numeric digits 100
do i = 1 to words(w)
   x = word(w,i); call time('r'); r = Gamma(x); e = format(time('e'),,3)
   say 'Formulas' format(x,4,1) r '('e 'seconds)'
end
say
say 'Lanczos (max 60 digits) vs Spouge (no limit) vs Stirling (no limit) approximation'
w = '-12.8 -6.4 -3.2 -1.6 -0.8 -0.4 -0.2 -0.1 0.1 0.2 0.4 0.8 1.6 3.2 6.4 12.8'
do i = 1 to words(w)
   x = word(w,i)
   numeric digits 60
   call time('r'); r = Gamma(x); e = format(time('e'),,3)
   say 'Lanczos ' format(x,4,1) r '('e 'seconds)'
   numeric digits 61
   call time('r'); r = Gamma(x); e = format(time('e'),,3)
   say 'Spouge  ' format(x,4,1) r '('e 'seconds)'
   if x > 0 then do
      call time('r'); r = Stirling(x); e = format(time('e'),,3)
      say 'Stirling' format(x,4,1) r '('e 'seconds)'
   end
end
say
say 'Same for a bigger number'
w = '-99.9 99.9'
do i = 1 to words(w)
   x = word(w,i)
   numeric digits 60
   call time('r'); r = Gamma(x); e = format(time('e'),,3)
   say 'Lanczos ' format(x,4,1) r '('e 'seconds)'
   numeric digits 100
   call time('r'); r = Gamma(x); e = format(time('e'),,3)
   say 'Spouge  ' format(x,4,1) r '('e 'seconds)'
   if x > 0 then do
      call time('r'); r = Stirling(x); e = format(time('e'),,3)
      say 'Stirling' format(x,4,1) r '('e 'seconds)'
   end
end
exit

Gamma:
/* Gamma */
procedure expose glob.
arg x
/* Validity */
if x < 1 & Whole(x) then
   return 'X'
/* Formulas for negative and positive (half)integers */
if x < 0 then do
   if Half(x) then do
      numeric digits Digits()+2
      i = Abs(Floor(x)); y = (-1)**i*2**(2*i)*Fact(i)*Sqrt(Pi())/Fact(2*i)
      numeric digits Digits()-2
      return y+0
   end
end
if x > 0 then do
   if Whole(x) then
      return Fact(x-1)
   if Half(x) then do
      numeric digits Digits()+2
      i = Floor(x); y = Fact(2*i)*Sqrt(Pi())/(2**(2*i)*Fact(i))
      numeric digits Digits()-2
      return y+0
   end
end
p = Digits()
if p < 61 then do
/* Lanczos with predefined coefficients */
/* Map negative x to positive x */
   if x < 0 then
      return Pi()/(Gamma(1-x)*Sin(Pi()*x))
/* Argument reduction to interval (0.5,1.5) */
   numeric digits p+2
   c = Trunc(x); x = x-c
   if x < 0.5 then do
      x = x+1; c = c-1
   end
/* Series coefficients 1/Gamma(x) in 80 digits Fransen & Wrigge */
    c.1 =  1.00000000000000000000000000000000000000000000000000000000000000000000000000000000
    c.2 =  0.57721566490153286060651209008240243104215933593992359880576723488486772677766467
    c.3 = -0.65587807152025388107701951514539048127976638047858434729236244568387083835372210
    c.4 = -0.04200263503409523552900393487542981871139450040110609352206581297618009687597599
    c.5 =  0.16653861138229148950170079510210523571778150224717434057046890317899386605647425
    c.6 = -0.04219773455554433674820830128918739130165268418982248637691887327545901118558900
    c.7 = -0.00962197152787697356211492167234819897536294225211300210513886262731167351446074
    c.8 =  0.00721894324666309954239501034044657270990480088023831800109478117362259497415854
    c.9 = -0.00116516759185906511211397108401838866680933379538405744340750527562002584816653
   c.10 = -0.00021524167411495097281572996305364780647824192337833875035026748908563946371678
   c.11 =  0.00012805028238811618615319862632816432339489209969367721490054583804120355204347
   c.12 = -0.00002013485478078823865568939142102181838229483329797911526116267090822918618897
   c.13 = -0.00000125049348214267065734535947383309224232265562115395981534992315749121245561
   c.14 =  0.00000113302723198169588237412962033074494332400483862107565429550539546040842730
   c.15 = -0.00000020563384169776071034501541300205728365125790262933794534683172533245680371
   c.16 =  0.00000000611609510448141581786249868285534286727586571971232086732402927723507435
   c.17 =  0.00000000500200764446922293005566504805999130304461274249448171895337887737472132
   c.18 = -0.00000000118127457048702014458812656543650557773875950493258759096189263169643391
   c.19 =  0.00000000010434267116911005104915403323122501914007098231258121210871073927347588
   c.20 =  0.00000000000778226343990507125404993731136077722606808618139293881943550732692987
   c.21 = -0.00000000000369680561864220570818781587808576623657096345136099513648454655443000
   c.22 =  0.00000000000051003702874544759790154813228632318027268860697076321173501048565735
   c.23 = -0.00000000000002058326053566506783222429544855237419746091080810147188058196444349
   c.24 = -0.00000000000000534812253942301798237001731872793994898971547812068211168095493211
   c.25 =  0.00000000000000122677862823826079015889384662242242816545575045632136601135999606
   c.26 = -0.00000000000000011812593016974587695137645868422978312115572918048478798375081233
   c.27 =  0.00000000000000000118669225475160033257977724292867407108849407966482711074006109
   c.28 =  0.00000000000000000141238065531803178155580394756670903708635075033452562564122263
   c.29 = -0.00000000000000000022987456844353702065924785806336992602845059314190367014889830
   c.30 =  0.00000000000000000001714406321927337433383963370267257066812656062517433174649858
   c.31 =  0.00000000000000000000013373517304936931148647813951222680228750594717618947898583
   c.32 = -0.00000000000000000000020542335517666727893250253513557337960820379352387364127301
   c.33 =  0.00000000000000000000002736030048607999844831509904330982014865311695836363370165
   c.34 = -0.00000000000000000000000173235644591051663905742845156477979906974910879499841377
   c.35 = -0.00000000000000000000000002360619024499287287343450735427531007926413552145370486
   c.36 =  0.00000000000000000000000001864982941717294430718413161878666898945868429073668232
   c.37 = -0.00000000000000000000000000221809562420719720439971691362686037973177950067567580
   c.38 =  0.00000000000000000000000000012977819749479936688244144863305941656194998646391332
   c.39 =  0.00000000000000000000000000000118069747496652840622274541550997151855968463784158
   c.40 = -0.00000000000000000000000000000112458434927708809029365467426143951211941179558301
   c.41 =  0.00000000000000000000000000000012770851751408662039902066777511246477487720656005
   c.42 = -0.00000000000000000000000000000000739145116961514082346128933010855282371056899245
   c.43 =  0.00000000000000000000000000000000001134750257554215760954165259469306393008612196
   c.44 =  0.00000000000000000000000000000000004639134641058722029944804907952228463057968680
   c.45 = -0.00000000000000000000000000000000000534733681843919887507741819670989332090488591
   c.46 =  0.00000000000000000000000000000000000032079959236133526228612372790827943910901464
   c.47 = -0.00000000000000000000000000000000000000444582973655075688210159035212464363740144
   c.48 = -0.00000000000000000000000000000000000000131117451888198871290105849438992219023663
   c.49 =  0.00000000000000000000000000000000000000016470333525438138868182593279063941453996
   c.50 = -0.00000000000000000000000000000000000000001056233178503581218600561071538285049997
   c.51 =  0.00000000000000000000000000000000000000000026784429826430494783549630718908519485
   c.52 =  0.00000000000000000000000000000000000000000002424715494851782689673032938370921241
/* Series expansion */
   x = x-1; s = 0
   do k = 52 by -1 to 1
      s = s*x+c.k
   end
   y = 1/s
/* Undo reduction */
   if c = -1 then
      y = y/x
   else do
      do i = 1 to c
         y = (x+i)*y
      end
   end
end
else do
   x = x-1
/* Spouge */
/* Estimate digits and iterations */
   q = Floor(p*1.5); a = Floor(p*1.3)
   numeric digits q
/* Series */
   s = 0
   do k = 1 to a-1
      s = s+((-1)**(k-1)*Power(a-k,k-0.5)*Exp(a-k))/(Fact(k-1)*(x+k))
   end
   s = s+Sqrt(2*Pi()); y = Power(x+a,x+0.5)*Exp(-a-x)*s
end
/* Normalize */
numeric digits p
return y+0

Stirling:
/* Sterling */
procedure expose glob.
arg x
return sqrt(2*pi()/x) * power(x/e(),x)

E:
/* Euler number */
procedure expose glob.
p = Digits()
/* In memory? */
if glob.e.p <> '' then
   return glob.e.p
if p < 101 then
/* Fast value */
   glob.e.p = 2.71828182845904523536028747135266249775724709369995957496696762772407663035354759457138217852516643+0
else do
   numeric digits Digits()+2
/* Taylor series */
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

Exp:
/* Exponential e^x */
procedure expose glob.
arg x
numeric digits Digits()+2
/* Fast values */
if Whole(x) then
   return E()**x
/* Argument reduction */
i = x%1
if Abs(x-i) > 0.5 then
   i = i+Sign(x)
/* Taylor series */
x = x-i; y = 1; t = 1; v = y
do n = 1
   t = (t*x)/n; y = y+t
   if y = v then
      leave
   v = y
end
/* Inverse reduction */
y = y*e()**i
numeric digits Digits()-2
return y+0

Fact:
/* Factorial n! */
procedure expose glob.
arg x
/* Validity */
if \ Whole(x) then
   return 'X'
if x < 0 then
   return 'X'
/* Current in memory? */
if glob.fact.x <> '' then
   return glob.fact.x
w = x-1
/* Previous in memory? */
if glob.fact.w = '' then do
/* Loop cf definition */
   y = 1
   do n = 2 to x
      y = y*n
   end
   glob.fact.x = y
end
else
/* Multiply */
   glob.fact.x = glob.fact.w*x
return glob.fact.x

Floor:
/* Floor */
procedure expose glob.
arg x
/* Formula */
if Whole(x) then
   return x
else
   return Trunc(x)-(x<0)

Frac:
/* Fractional part */
procedure expose glob.
arg x
/* Formula */
return x-x%1

Half:
/* Is a number half integer? */
procedure expose glob.
arg x
/* Formula */
return (Frac(Abs(x))=0.5)

Ln:
/* Natural logarithm base e */
procedure expose glob.
arg x
/* Validity */
if x <= 0 then
   return 'X'
/* Fast values */
if x = 1 then
   return 0
p = Digits()
/* In memory? */
if glob.ln.x.p <> '' then
   return glob.ln.x.p
/* Precalculated values */
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
/* Argument reduction */
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
/* Taylor series */
q = (z-1)/(z+1); f = q; y = q; v = q; q = q*q
do n = 3 by 2
   f = f*q; y = y+f/n
   if y = v then
      leave
   v = y
end
numeric digits p
/* Inverse reduction */
glob.ln.x.p = 2*y+i
return glob.ln.x.p

Power:
/* Power function x^y */
procedure expose glob.
arg x,y
/* Validity */
if x < 0 then
   return 'X'
/* Fast values */
if x = 0 then
   return 0
if y = 0 then
   return 1
/* Fast formula */
if Whole(y) then
   return x**y
/* Formulas */
if Abs(y//1) = 0.5 then
   return Sqrt(x)**Sign(y)*x**(y%1)
else
   return Exp(y*Ln(x))

Sin:
/* Sine */
procedure expose glob.
arg x
numeric digits Digits()+2
/* Argument reduction */
u = Pi(); x = x//(2*u)
if Abs(x) > u then
   x = x-Sign(x)*2*u
/* Taylor series */
t = x; y = x; x = x*x; v = y
do n = 2 by 2
   t = -t*x/(n*(n+1)); y = y+t
   if y = v then
      leave
   v = y
end
numeric digits Digits()-2
return y+0

Sqrt:
/* Square root x^(1/2) */
procedure expose glob.
arg x
/* Validity */
if x < 0 then
   return 'X'
/* Fast values */
if x = 0 then
   return 0
if x = 1 then
   return 1
p = Digits()
/* Predefined values */
if x = 2 & p < 101 then
   return Sqrt2()
if x = 3 & p < 101 then
   return Sqrt3()
if x = 5 & p < 101 then
   return Sqrt5()
numeric digits p+2
/* Argument reduction to [0,100) */
i = Xpon(x); i = (i-(i<0))%2; x = x/100**i
/* First guess 1 digit accurate */
t = '2.5 6.5 12.5 20.5 30.5 42.5 56.5 72.5 90.5 100'
do y = 1 until word(t,y) > x
end
/* Dynamic precision */
d = Digits()
do n = 1 while d > 2
   d.n = d; d = d%2+1
end
d.n = 2
/* Method Heron */
do k = n to 1 by -1
   numeric digits d.k
   y = (y+x/y)*0.5
end
numeric digits p
return y*10**i

Whole:
/* Is a number integer? */
procedure expose glob.
arg x
/* Formula */
return Datatype(x,'w')

Xpon:
/* Exponent */
procedure expose glob.
arg x
/* Formula */
if x = 0 then
   return 0
else
   return Right(x*1E+99999,6)-99999

Ln2:
/* Natural log of 2 */
procedure expose glob.
/* Fast value */
y = 0.6931471805599453094172321214581765680755001343602552541206800094933936219696947156058633269964186875
return y+0

Ln4:
/* Natural log of 4 */
procedure expose glob.
/* Fast value */
y = 1.386294361119890618834464242916353136151000268720510508241360018986787243939389431211726653992837375
return y+0

Ln8:
/* Natural log of 8 */
procedure expose glob.
/* Fast value */
y = 2.079441541679835928251696364374529704226500403080765762362040028480180865909084146817589980989256063
return y+0

Ln10:
/* Natural log of 10 */
procedure expose glob.
/* Fast value */
y = 2.30258509299404568401799145468436420760110148862877297603332790096757260967735248023599720508959830
return y+0

Pi:
/* Pi */
procedure expose glob.
p = Digits()
/* In memory? */
if glob.pi.p <> '' then
   return glob.pi.p
if p < 101 then
/* Fast value */
   glob.pi.p = 3.14159265358979323846264338327950288419716939937510582097494459230781640628620899862803482534211707+0
else do
   numeric digits Digits()+2
   if p < 201 then do
/* Method Chudnovsky series */
      y = 0
      do n = 0
         v = y; y = y + Fact(6*n)*(13591409+545140134*n)/(Fact(3*n)*Fact(n)**3*-640320**(3*n))
         if y = v then
            leave
      end
      y = 4270934400/(Sqrt(10005)*y)
   end
   else do
/* Method Agmean series */
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

Sqrt2:
/* Square root of 2 */
procedure expose glob.
/* Fast value */
y = 1.414213562373095048801688724209698078569671875376948073176679737990732478462107038850387534327641573
return y+0

Sqrt3:
/* Square root of 3 */
procedure expose glob.
/* Fast value */
y = 1.732050807568877293527446341505872366942805253810380628055806979451933016908800037081146186757248576
return y+0

Sqrt5:
/* Square root of 5 */
procedure expose glob.
/* Fast value */
y = 2.236067977499789696409173668731276235440618359611525724270897245410520925637804899414414408378782275
return y+0

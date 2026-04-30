-- 21 Feb 2026
include Setting
numeric digits 30

say 'KAPREKAR NUMBERS'
say version
say
-- Brute-force
call Task1 1E4
call Task1 1E6
call Timer 'R'
-- Generator
call Generator 1E9
call Task2 1E9
call Timer 'R'
-- Generator stretched
call Generator 1E15
call Task2 1E12
call Task3 1E15
call Timer 'R'
-- Definition base NN
call Task4 1E6,17
call Task4 1E6,36
call Timer 'R'
exit

Task1:
-- Shows Kaprekar numbers below threshold
-- Brute-force casting out nines
procedure
arg xx
say 'Brute-force: Kaprekar numbers up to' xx
call CharOut ,Right(1,14)
n=1
do i=9 for xx-9
   a=i//9
   if a>2 then
      iterate i
   s=i*i
   if a=s//9 then do
      do j=1 to Length(s)%2
         parse var s l +(j) r
         if i<>l+r then
            iterate j
         n+=1
         call CharOut ,Right(i,14)
         if n//5=0 then
            say
         leave
      end j
   end
end i
say
say n 'found'
say
return

Generator:
-- Generate Kaprekar numbers up to threshold*10
-- Cf paper 'The Kaprekar numbers' Iannuci 2000
procedure expose Divi. Kapr. Memo. Udiv.
arg xx
say 'Generate up to 10x'xx'...'
xx*=10
Kapr.=1; n=1
do y=1 until yy=xx-1
   yy=10**y-1; n+=1; Kapr.n=yy
   u=UnitDivs(yy)
   do i=2 to u%2
      d=Udiv.i; k=d*ModMultInv(d,(yy)/d); n+=1; Kapr.n=k
      k=yy-k+1; n+=1; Kapr.n=k
   end i
end y
Kapr.0=n
call SortSt 'Kapr.'
say n 'found'
say
return 0

UnitDivs:
-- Unitary divisors of an integer
procedure expose Divi. Memo. Udiv.
arg xx
-- Fast
Udiv.=1
if xx=1 then
   return 1
call DivisorS xx
rr=1
do i=2 to Divi.0
   a=Divi.i
   if Gcd(a,xx/a)=1 then do
      rr+=1; Udiv.rr=a
   end
end
Udiv.0=rr
return rr

ModMultInv:
-- Modular multiplicative inverse
-- Extended Euclidian algorithm
procedure
arg xx,yy
if yy=1 then
   return 1
rr=0; nr=1; aa=yy; na=xx
do while na <> 0
   q=aa%na
   parse value nr rr-q*nr with rr nr
   parse value na aa-q*na with aa na
end
if aa>1 then
   rr=0
if rr<0 then
   rr+=yy
return rr

Task2:
-- Shows numbers from the generated array
procedure expose Kapr.
arg xx
say 'Generator: Kaprekar numbers up to' xx
do i=1 to Kapr.0 until Kapr.i=xx-1
   call CharOut ,Right(Kapr.i,14)
   if i//5=0 then
      say
end
say
say i 'found'
say
return 0

Task3:
-- Shows count from the generated array
procedure expose Kapr.
arg xx
say 'Generator: Kaprekar number count'
p=1; pp=10
do i=1 to Kapr.0
   if Kapr.i>pp then do
      say 'There are' Right(i-1,3) 'Kaprekar numbers below 10^'p
      p+=1; pp*=10
   end
end
say
return 0

Task4:
-- Shows Kaprekar numbers below threshold in base 17
-- Brute-force method cf definition
procedure
arg xx,yy
say 'Brute-force: Kaprekar numbers up to' xx 'in base'yy
say 'No  Base10  Base'yy 'Square     Sum'
say 1
n=1
do i=2 to xx
   ib=D2n(i,yy); j=i*i; jb=D2n(j,yy); jl=Length(jb)
   do k=2 to jl%2+1
      lb=Left(jb,k-1); rb=Right(jb,jl-k+1)
      if rb=0 then
         leave k
      if AddB(lb,rb,yy)=ib then do
         n+=1
         say Left(n,3) Left(i,7) Left(ib,6) Left(jb,10) Left(lb'+'rb,10)
      end
   end k
end i
say
return

-- AddB; D2n; DivisorS; Gcd; SortSt; Timer
include Math

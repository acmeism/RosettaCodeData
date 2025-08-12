-- 28 Jul 2025
include Settings
arg n
if n = '' then
   n = 100
numeric digits n

say 'GAMMA'
say version
say
say '(Half)integers formulas'
w = '-99.5 -10.5 -5.5 -2.5 -1.5 -0.5 0.5 1 1.5 2 2.5 5 5.5 10 10.5 99 99.5'
numeric digits n
do i = 1 to Words(w)
   x = Word(w,i); call Time('r'); r = Gamma(x); e = Format(Time('e'),,3)
   say 'Formulas' Format(x,4,1) r '('e 'seconds)'
end
say
say 'Lanczos (max 60 decimals) vs Spouge (no limit) vs Stirling (no limit) approximation'
w = '-12.8 -6.4 -3.2 -1.6 -0.8 -0.4 -0.2 -0.1 0.1 0.2 0.4 0.8 1.6 3.2 6.4 12.8'
do i = 1 to Words(w)
   x = Word(w,i)
   numeric digits Min(60,n)
   call Time('r'); r = Gamma(x)+0; e = Format(Time('e'),,3)
   say 'Lanczos ' Format(x,4,1) r '('e 'seconds)'
   numeric digits n
   call Time('r'); r = Gamma(x)+0; e = Format(Time('e'),,3)
   say 'Spouge  ' Format(x,4,1) r '('e 'seconds)'
   if x > 0 then do
      call Time('r'); r = Stirling(x)+0; e = Format(Time('e'),,3)
      say 'Stirling' Format(x,4,1) r '('e 'seconds)'
   end
end
say
say 'Same for a bigger number'
w = '-99.9 99.9'
do i = 1 to Words(w)
   x = Word(w,i)
   numeric digits Min(60,n)
   call Time('r'); r = Gamma(x)+0; e = Format(Time('e'),,3)
   say 'Lanczos ' Format(x,4,1) r '('e 'seconds)'
   numeric digits n
   call Time('r'); r = Gamma(x)+0; e = Format(Time('e'),,3)
   say 'Spouge  ' Format(x,4,1) r '('e 'seconds)'
   if x > 0 then do
      call Time('r'); r = Stirling(x)+0; e = Format(Time('e'),,3)
      say 'Stirling' Format(x,4,1) r '('e 'seconds)'
   end
end
exit

Stirling:
procedure expose Memo. fact.
arg x
return Sqrt(2*Pi()/x) * Power(x/e(),x)

include Math

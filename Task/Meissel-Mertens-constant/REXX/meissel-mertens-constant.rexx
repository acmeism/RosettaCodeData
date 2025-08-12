-- 28 Jul 2025
include Settings
arg n
if n = '' then
   n = 16
numeric digits n

say 'MEISSEL-MERTENS CONSTANT'
say version
say
fact. = 0
call Time('r'); a = BruteForce(); e = Format(Time('e'),,3)
say 'BruteForce' a '('e 'seconds)'
call Time('r'); a = UsingSieve(); e = Format(Time('e'),,3)
say 'UsingSieve' a '('e 'seconds)'
call Time('r'); a = Analytic(); e = Format(Time('e'),,3)
say 'Analytic  ' a '('e 'seconds)'
call Time('r'); a = TrueValue(); e = Format(Time('e'),,3)
say 'True value' a '('e 'seconds)'
exit

BruteForce:
procedure expose Memo.
numeric digits Digits()+2
y = 0.5-Ln(2)
do n = 3 by 2 to 1000000
   if Prime(n) then do
      q = 1/n; t = Ln(1-q)+q; y = y+t
   end
end
y = Euler()+y
numeric digits Digits()-2
return y+0

UsingSieve:
procedure expose Memo. prim. flag.
numeric digits Digits()+2
n = Primes(1000000); y = 0
do i = 1 to n
   q = 1/prim.i; t = Ln(1-q)+q; y = y+t
end
y = Euler()+y
numeric digits Digits()-2
return y+0

Analytic:
procedure expose Memo. fact.
numeric digits Digits()+2
y = 0; v = 0
do n = 2 to 1000
   t = Moebius(n) * Ln(Zeta(n)) / n
   if t <> 0 then do
      y = y+t
      if y = v then
         leave
      v = y
   end
end
y = Euler()+y
numeric digits Digits()-2
return y+0

TrueValue:
procedure
return 0.261497212847642783755426838608695859051566648261199206192064213924924510897368209714142631434246651051617+0

include Math

-- 8 May 2025
say 'FIRST FEIGENBAUM CONSTANT'
say 'Using algorithm cf RosettaCode, correct to about 11 decimals'
say
arg n; if n = '' then n = 30; numeric digits n
call Time('r'); a = Original(); e = Format(Time('e'),,3)
say 'Original  ' a '('e 'seconds)'
call Time('r'); a = Optimized(); e = Format(Time('e'),,3)
say 'Optimized ' a '('e 'seconds)'
call Time('r'); a = TrueValue(); e = Format(Time('e'),,3)
say 'True value' a '('e 'seconds)'
exit

Original:
procedure expose glob.
/* Outer 2 loops with a fixed value */
numeric digits Digits()+2
im = 20; jm = 10
a1 = 1; a2 = 0; d1 = 3.2
do i = 2 to im
   a = a1 + (a1-a2)/d1
   do j = 1 to jm
      x = 0; y = 0
      do k = 1 to 2**i
         y = 1 - 2*x*y; x = a - x*x
      end
      a = a - x/y
   end
   d = (a1-a2) / (a-a1)
   parse value d a1 a with d1 a2 a1
end
numeric digits Digits()-2
return d+0

Optimized:
procedure expose glob.
/* Center loop stops on achieving desired accuracy */
numeric digits Digits()+4; numeric fuzz 4
/* Only outer loop maximum */
im = 20
a1 = 1; a2 = 0; d1 = 3.2
do i = 2 to im
   a = a1 + (a1-a2)/d1; v = 0
   do forever
      x = 0; y = 0
      do 2**i
         y = 1 - 2*x*y; x = a - x*x
      end
      a = a - x/y
/* Stop second loop when a does not change anymore */
      if a = v then
         leave
      v = a
   end
   d = (a1-a2) / (a-a1)
   parse value d a1 a with d1 a2 a1
   say Format(i,2) Format(d,1,12)
end
numeric digits Digits()-4
return d+0

TrueValue:
procedure expose glob.
return 4.66920160910299067185320382046620161725818557747576863274565134300413433021131473713868974402394801381716+0

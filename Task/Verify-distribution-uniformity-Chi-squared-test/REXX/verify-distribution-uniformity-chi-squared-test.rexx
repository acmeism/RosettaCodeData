-- 28 Jul 2025
include Settings

say 'VERIFY DISTRIBUTION UNIFORMITY / CHI-SQUARED TEST'
say version
say
call Check '200000 200000 200000 200000 200000'
call Check '199809 200665 199607 200270 199649'
call Check '522573 244456 139979  71531  21461'
call Check 'Random'
call Timer
exit

Check:
procedure expose stat. Memo.
arg xx
-- Dataset
stat. = 0
if xx = 'RANDOM' then do
   do i = 1 to 1000000
      a = Random(1,5); stat.a = stat.a+1
   end
   stat.0 = 5
   say 'Dataset Random     ' stat.1 stat.2 stat.3 stat.4 stat.5
end
else do
   do i = 1 to Words(xx)
      stat.i = Word(xx,i)
   end
   stat.0 = Words(xx)
   say 'Dataset Specified  ' xx
end
say 'Categories (bins)  ' stat.0
say 'Degrees of freedom ' stat.0-1
-- Samples
sa = 0
do i = 1 to stat.0
   sa = sa+stat.i
end
say 'Samples            ' sa
-- Significant at
sl = 1/20; sp = sl*100/1
say 'Signicant tested at' sp'%'
-- Chi-Squared test value
s = 0; e = 0
do i = 1 to stat.0
   e = e+stat.i
end i
e = e/stat.0
do i = 1 to stat.0
   s = s+(stat.i-e)**2
end i
csv = s/e
say 'Distance           ' csv
-- Probability test value
pv = 1-RliGamma((stat.0-1)/2,csv/2)
say 'Probability        ' pv
-- Result
say 'Is dataset uniform?' Word('Yes No',(Abs(pv)<csv*sl)+1)
say
return

include Math

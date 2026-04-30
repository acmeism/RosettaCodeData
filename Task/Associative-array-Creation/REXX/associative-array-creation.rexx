-- 21 Feb 2026
include Setting

say 'ASSOCIATIVE ARRAY: CREATION'
say version
say
say 'Basic examples...'
cap.='Unknown'
cap.be='Brussels'
cap.fr='Paris'
cap.uk='London'
call Capital 'BE'
call Capital 'UK'
call Capital 'NO'
day.='Unknown'; week.='Unknown'
day.jan.2=2; week.jan.2=1
day.mar.17=76; week.mar.17=12
day.aug.7=219; week.aug.7=32
call Calendar 'JAN',2
call Calendar 'AUG',7
call Calendar 'MAY',16
say
say 'Keys can have any value...'
a.cat='civet'; say 'a.cat =' a.cat
a1='dog'; a.a1='pitbull'
a2=a1; say 'a.'a2 '=' a.a2
a1='x.y.z'; a.a1='periods'
a2=a1; say 'a.'a2 '=' a.a2
a1='x y z'; a.a1='spaces'
a2=a1; say 'a.'a2 '=' a.a2
a1='└┴┬├─┼'; a.a1='special characters'
a2=a1; say 'a.'a2 '=' a.a2
say
call Showvars
exit

Capital:
arg country
say 'The capital of' country 'is' cap.country
return

Calendar:
arg mm,dd
say mm dd 'is day no' day.mm.dd 'and week no' week.mm.dd
return

-- Showvars
include Math

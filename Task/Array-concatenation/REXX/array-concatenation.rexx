-- 1 Jun 2025
include Settings

say 'ARRAY CONCATENATION'
say version
say
say 'Two numbered arrays concatenated...'
a.1=1; a.2=4; a.3=9
b.1=16; b.2=25; b.3=36
a.0=3; b.0=3
j=a.0
do i = 1 to 3
   j=j+1; a.j=b.i
end
a.0=j
do i = 1 to a.0
   say i a.i
end
exit

include Abend

include Settings

say version; say 'Humble numbers'; say
call Humbles 50
call ShowFirstN 50
call Humbles 1e7
call ShowDistribution
exit

Humbles:
procedure expose humb.
arg xx
call Time('r')
xx = xx/1
say 'Collect humble numbers up to the' xx'th'
/* Ensure enough digits */
numeric digits 2**(Length(xx)+1)
/* Dijkstra */
humb.humble.1 = 1
x2 = 2; x3 = 3; x5 = 5; x7 = 7; i2 = 1; i3 = 1; i5 = 1; i7 = 1
do yy = 2
   h = x2
   if x3 < h then
      h = x3
   if x5 < h then
      h = x5
   if x7 < h then
      h = x7
   humb.humble.yy = h
   if yy = xx then
      leave
   if x2 = h then do
      i2 = i2+1; x2 = humb.humble.i2+humb.humble.i2
   end
   if x3 = h then do
      i3 = i3+1; x3 = humb.humble.i3+humb.humble.i3+humb.humble.i3
   end
   if x5 = h then do
      i5 = i5+1; x5 = humb.humble.i5*5
   end
   if x7 = h then do
      i7 = i7+1; x7 = humb.humble.i7*7
   end
end
humb.0 = yy
say Time('e')/1 'seconds'
say
return

ShowFirstN:
procedure expose humb.
arg xx
call Time('r')
xx = xx/1
say 'First' xx 'humble numbers are'
do i = 1 to xx
   call Charout ,Right(humb.humble.i,4)
   if i//10 = 0 then
      say
end
say Time('e')/1 'seconds'
say
return

ShowDistribution:
procedure expose humb.
call Time('r')
say 'Digit distribution for the first' humb.0 'humble numbers'
d. = 0
do i = 1 to humb.0
   l = Length(humb.humble.i); d.l = d.l + 1; d.0 = Max(l,d.0)
end
l = Copies('-',17)
say l
say 'Dg  Count     Cum'
say l
c = 0
do i = 1 to d.0-1
   c = c + d.i
   say Right(i,2) Right(d.i,6) Right(c,7)
end
say l
say Time('e')/1 'seconds'
return

include Abend

include Settings

say version; say 'Hamming numbers'; say
call Hammings 1e6
call ShowFirstN 20
call ShowNth 1691
call ShowNth 1e6
call Hammings 1e7
call ShowNth 1e7
exit

Hammings:
procedure expose hamm.
arg xx
call Time('r')
xx = xx/1
say 'Collect Hamming numbers up to the' xx'th'
/* Ensure enough digits */
numeric digits 2**(Length(xx)+1)
/* Dijkstra */
hamm.hamming.1 = 1
x2 = 2; x3 = 3; x5 = 5; i2 = 1; i3 = 1; i5 = 1
do yy = 2
   h = x2
   if x3 < h then
      h = x3
   if x5 < h then
      h = x5
   hamm.hamming.yy = h
   if yy = xx then
      leave
   if x2 = h then do
      i2 = i2+1; x2 = hamm.hamming.i2+hamm.hamming.i2
   end
   if x3 = h then do
      i3 = i3+1; x3 = hamm.hamming.i3+hamm.hamming.i3+hamm.hamming.i3
   end
   if x5 = h then do
      i5 = i5+1; x5 = hamm.hamming.i5*5
   end
end
hamm.0 = yy
say Time('e')/1 'seconds'
say
return

ShowFirstN:
procedure expose hamm.
arg xx
call Time('r')
xx = xx/1
say 'First' xx 'Hamming numbers are'
do i = 1 to xx
   call Charout ,Right(hamm.hamming.i,5)
   if i//10 = 0 then
      say
end
say Time('e')/1 'seconds'
say
return

ShowNth:
procedure expose hamm.
arg xx
xx = xx/1
call Time('r')
say xx'th Hamming Number is'
say hamm.hamming.xx '('Length(hamm.hamming.xx) 'digits)'
say Time('e')/1 'seconds'
say
return

include Abend

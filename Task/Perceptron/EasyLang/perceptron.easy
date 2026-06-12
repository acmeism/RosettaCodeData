func f x .
   return 0.5 * x - 1
.
func outpf a b .
   if f a < b : return 1
   return -1
.
global w[] data[][] count .
#
proc init .
   for i to 3 : w[] &= randomf * 2 - 1
   for i to 2000
      x = randomf * 200 - 100
      y = randomf * 200 - 100
      data[][] &= [ x y 1 ]
   .
.
init
func forward inp[] .
   for i to 3 : sum += inp[i] * w[i]
   if sum > 0 : return 1
   return -1
.
lrate = 0.01
proc train inp[] .
   inp[] &= 1
   err = outpf inp[1] inp[2] - forward inp[]
   for j to 3 : w[j] += err * inp[j] * lrate
   lrate *= 0.999
.
#
coord_translate 50 50
coord_scale 0.5
numfmt 0 3
gtextsize 6
#
proc show .
   gclear
   gcolor -1
   gline -100 f -100 100 f 100
   gcolor 990
   a = -w[1] / w[2]
   b = -w[3] / w[2]
   gline -100, -100 * a + b, 100, 100 * a + b
   for d[] in data[][]
      if forward d[] = 1
         gcolor 070
      else
         gcolor 700
      .
      gcircle d[1] d[2] 1.5
   .
   gcolor -2
   grect -100 -100 200 7
   gcolor -1
   gtext -99 -99 "Count:" & count & " L-Rate:" & lrate & " Weights:" & strjoin w[] ","
   sleep 0.01
.
proc main .
   for count to len data[][]
      train data[count][]
      show
   .
.
main

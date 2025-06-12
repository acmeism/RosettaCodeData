func$ rep c$ n .
   for i to n : r$ &= c$
   return r$
.
func modifier x .
   if x < 0.5 : return 2 * (0.5 - x)
   return 2 * (x - 0.5)
.
func rand .
   repeat
      r1 = randomf
      r2 = randomf
      until r2 < modifier r1
   .
   return r1
.
n = 100000
nbins = 20
histsz = 200
binsz = 1 / nbins
len bins[] nbins
arrbase bins[] 0
#
for i to n
   rn = rand
   bn = floor (rn / binsz)
   bins[bn] += 1
.
numfmt 4 0
for i range0 nbins
   print bins[i] & " " & rep "*" (bins[i] / histsz)
.

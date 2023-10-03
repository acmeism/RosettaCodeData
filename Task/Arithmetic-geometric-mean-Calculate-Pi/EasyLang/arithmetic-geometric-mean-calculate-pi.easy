an = 1
bn = sqrt 0.5
tn = 0.25
pn = 1
while pn <= 5
   prevAn = an
   an = (bn + an) / 2
   bn = sqrt (bn * prevAn)
   prevAn -= an
   tn -= (pn * prevAn * prevAn)
   pn *= 2
.
mypi = (an + bn) * (an + bn) / (tn * 4)
numfmt 15 0
print mypi

import random

nquads = 5
maxgenerations = 10
fmt = '%%0%ix'%nquads
nbits = 4*nquads
a = random.getrandbits(nbits)  << 1
#a = int('01110110101010100100', 2) << 1
endmask = (2<<nbits)-2;
endvals = 0<<(nbits+1) | 0
tr = ('____', '___#', '__#_', '__##', '_#__', '_#_#', '_##_', '_###',
      '#___', '#__#', '#_#_', '#_##', '##__', '##_#', '###_', '####' )
for i in range(maxgenerations):
   print "Generation %3i:  %s" % (i,(''.join(tr[int(t,16)] for t in (fmt%(a>>1)))))
   a |= endvals
   a = ((a&((a<<1) | (a>>1))) ^ ((a<<1)&(a>>1))) & endmask

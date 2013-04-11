require 'files'            NB.  for fwrites

x          =.  1 2 3 1e11
y          =.  %: x        NB.  y is sqrt(x)

xprecision =.  3
yprecision =.  5

filename   =.  'whatever.txt'

data       =.  (0 j. xprecision,yprecision) ": x,.y

data fwrites filename

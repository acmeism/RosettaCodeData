var # creation
  s = {0,3,5,10}
  t = {3..20, 50..55}

if 5 in s: echo "5 is in!" # element test

var
  c = s + t # union
  d = s * t # intersection
  e = s - t # difference

if s <= t: echo "s ⊆ t" # subset

if s <= t: echo "s ⊂ t" # strong subset

if s == t: echo "s = s" # equality

s.incl(4) # add 4 to set
s.excl(5) # remove 5 from set

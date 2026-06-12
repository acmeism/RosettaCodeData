tf = 1000 # time factor adjustment for different Ring versions

? "working..."

? "turtle method:" # 3 nested loops is not a good approach,
                   # even when cheating by cherry-picking the loop start/end points...
st = clock()

for a = 100 to 400
     for b = 200 to 800
           for c = b to 1000 - a - b
                 if a + b + c = 1000
                       if a * a + b * b = c * c exit 3 ok
                 ok
           next
     next
next
et = clock() - st
? "a = " + a + " b = " + b + " c = " + c
? "Elapsed time = " + et / (tf * 1000) + " s" + nl

? "brutally forced method:" # eliminating the "c" loop speeds it up a bit
st = clock()

for a = 1 to 1000
      for b = a to 1000
            c = 1000 - a - b
            if a * a + b * b = c * c exit 2 ok
      next
next
et = clock() - st
? "a = " + a + " b = " + b + " c = " + c
? "Elapsed time = " + et / tf + " ms" + nl

# some basic info about this task:
p = 1000 pp = p * p >> 1      # perimeter, half of perimeter^2
maxc = ceil(sqrt(pp) * 2) - p # minimum c = 415 ceiling of ‭414.2135623730950488016887242097‬
maxa = (p - maxc) >> 1        # maximum a = 292, shorter leg will shrink
minb = p - maxc - maxa        # minimum b = 293, longer leg will lengthen

? "polished brute force method:" # calculated realistic limits for the loops,
                                 # cached some vars that didn't need recalcs over and over
st = clock()
minb = maxa + 1 maxb = p - maxc pma = p - 1
for a = 1 to maxa
      aa = a * a
      c = pma - minb
      for b = minb to maxb
            if aa + b * b = c * c exit 2 ok
            c--
      next
      pma--
next
et = clock() - st
? "a = " + a + " b = " + b + " c = " + c
? "Elapsed time = " + et / tf + " ms" + nl

? "quick method:" # down to one loop, using some math insight

st = clock()
n2 = p >> 1
for a = 1 to n2
      b = p * (n2 - a)
      if b % (p - a) = 0 exit ok
next
b /= (p - a)
? "a = " + a + " b = " + b + " c = " + (p - a - b)
et = clock() - st

? "Elapsed time = " + et / tf + " ms" + nl

? "even quicker method:" # generate primitive Pythagorean triples,
                         # then scale to fit the actual perimeter
st = clock()
md = 1 ms = 1
for m = 1 to 4
      nd = md + 2 ns = ms + nd
      for n = m + 1 to 5
            if p % (((n * m) + ns) << 1) = 0 exit 2 ok
            nd += 2 ns += nd
      next
      md += 2 ms += md
next
et = clock() - st
a = n * m << 1  b = ns - ms  c = ns + ms d = p / (((n * m) + ns) << 1)
? "a = " + a * d + " b = " + b * d + " c = " + c * d
? "Elapsed time = " + et / tf + " ms" + nl

? "alternate method:" # only uses addition / subtraction inside the loop.
                      # makes a guess, then tweaks the guess until correct
st = clock()
a = maxa b = minb
g = p * (a + b) - a * b     # guess
while g != pp
      if pp > g
            b++ g += p - a  # step "b" only when the "a" step went too far
      ok
      a-- g -= p - b        # step "a" on every iteration
end
et = clock() - st
? "a = " + a + " b = " + b + " c = " + (p - a - b)
? "Elapsed time = " + et / tf + " ms" + nl

see "done..."

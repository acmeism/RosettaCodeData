global rs[] ss[] .
procdecl RS_append . .
func R n .
   while n > len rs[]
      RS_append
   .
   return rs[n]
.
func S n .
   while n > len ss[]
      RS_append
   .
   return ss[n]
.
proc RS_append . .
   n = len rs[]
   r = R n + S n
   s = S len ss[]
   rs[] &= r
   repeat
      s += 1
      until s = r
      ss[] &= s
   .
   ss[] &= r + 1
.
rs[] = [ 1 ]
ss[] = [ 2 ]
write "R(1 .. 10): "
for i to 10
   write R i & " "
.
print ""
len seen[] 1000
for i to 40
   seen[R i] = 1
.
for i to 960
   seen[S i] = 1
.
for i to 1000
   if seen[i] = 0
      print i & " not seen"
      return
   .
.
print "first 1000 ok"

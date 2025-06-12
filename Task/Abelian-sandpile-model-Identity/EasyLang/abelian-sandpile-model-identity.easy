proc out s[] .
   for r = 0 to 2
      for c to 3 : write s[c + 3 * r] & " "
      print ""
   .
   print ""
.
proc stab &m[] .
   n = sqrt len m[]
   repeat
      stable = 1
      for p to len m[]
         if m[p] >= 4
            stable = 0
            m[p] -= 4
            if p > n : m[p - n] += 1
            if p mod n <> 0 : m[p + 1] += 1
            if p <= len m[] - n : m[p + n] += 1
            if p mod n <> 1 : m[p - 1] += 1
         .
      .
      until stable = 1
   .
.
func[] add s1[] s2[] .
   for i to len s1[] : r[] &= s1[i] + s2[i]
   stab r[]
   return r[]
.
print "avalanche:"
s4[] = [ 4 3 3 3 1 2 0 2 3 ]
stab s4[]
out s4[]
#
s1[] = [ 1 2 0 2 1 1 0 1 3 ]
s2[] = [ 2 1 3 1 0 1 0 1 0 ]
if add s1[] s2[] = add s2[] s1[]
   print "s1 + s2 = s2 + s1"
.
#
s3[] = [ 3 3 3 3 3 3 3 3 3 ]
s3_id[] = [ 2 1 2 1 0 1 2 1 2 ]
if add s3[] s3_id[] = s3[]
   print "s3 + s3_id = s3"
.
if add s3_id[] s3_id[] = s3_id[]
   print "s3_id + s3_id = s3_id"
.

proc merge . a[] b[] .
   a = 1 ; b = 1
   while a <= len a[] and b <= len b[]
      if a[a] < b[b]
         r[] &= a[a]
         a += 1
      else
         r[] &= b[b]
         b += 1
      .
   .
   while a <= len a[]
      r[] &= a[a]
      a += 1
   .
   while b <= len b[]
      r[] &= b[b]
      b += 1
   .
   swap a[] r[]
.
proc strand . a[] s[] .
   s[] = [ a[1] ]
   for i = 2 to len a[]
      if a[i] > s[$]
         s[] &= a[i]
      else
         an[] &= a[i]
      .
   .
   swap a[] an[]
.
proc strandsort . a[] .
   strand a[] out[]
   while len a[] > 0
      strand a[] b[]
      merge out[] b[]
   .
   swap a[] out[]
.
a[] = [ 1 6 3 2 1 7 5 3 ]
strandsort a[]
print a[]

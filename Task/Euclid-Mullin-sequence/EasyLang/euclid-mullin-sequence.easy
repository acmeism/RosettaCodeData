arr[] = [ 2 ]
fastproc .
   for i = 2 to 8
      k = 3
      repeat
         em = 1
         for j = 1 to i - 1
            em = em * arr[j] mod k
         .
         em = (em + 1) mod k
         until em = 0
         k += 2
      .
      arr[] &= k
   .
.
print arr[]

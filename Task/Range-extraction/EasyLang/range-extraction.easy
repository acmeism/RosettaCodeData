func$ mkrange arr[] .
   idx = 1
   idx2 = 1
   while idx <= len arr[]
      repeat
         idx2 += 1
         until idx2 > len arr[] or arr[idx2] - arr[idx2 - 1] <> 1
      .
      if idx2 - idx > 2
         r$ &= arr[idx] & "-" & arr[idx2 - 1] & ","
         idx = idx2
      else
         while idx < idx2
            r$ &= arr[idx] & ","
            idx += 1
         .
      .
   .
   return substr r$ 1 (len r$ - 1)
.
print mkrange [ 0 1 2 4 6 7 8 11 12 14 15 16 17 18 19 20 21 22 23 24 25 27 28 29 30 31 32 33 35 36 37 38 39 ]

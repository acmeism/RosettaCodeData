global dparr[] dpcols .
proc dpnew a b .
   len dparr[] a * b
   dpcols = b
.
func dp r c .
   return dparr[r * dpcols + c + 1]
.
proc dps r c v .
   dparr[r * dpcols + c + 1] = v
.
proc align a$ b$ &ar$ &br$ .
   dpnew (len a$ + 1) (len b$ + 1)
   for i = 1 to len a$ : dps i 0 i
   for j = 0 to len b$ : dps 0 j j
   for i = 1 to len a$ : for j = 1 to len b$
      if substr a$ i 1 = substr b$ j 1
         dps i j dp (i - 1) (j - 1)
      else
         dps i j lower (lower dp (i - 1) j dp i (j - 1)) dp (i - 1) (j - 1) + 1
      .
   .
   ar$ = "" ; br$ = ""
   i = len a$ ; j = len b$
   while i <> 0 and j <> 0
      if substr a$ i 1 = substr b$ j 1 or dp i j = dp (i - 1) (j - 1) + 1
         ar$ = substr a$ i 1 & ar$
         i -= 1
         br$ = substr b$ j 1 & br$
         j -= 1
      elif dp i j = dp (i - 1) j + 1
         ar$ = substr a$ i 1 & ar$
         i -= 1
         br$ = "-" & br$
      else
         ar$ = "-" & ar$
         br$ = substr b$ j 1 & br$
         j -= 1
      .
   .
.
align "rosettacode" "raisethysword" ar$ br$
print ar$ ; print br$

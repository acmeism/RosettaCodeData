fastfunc factor num .
   if num mod 2 = 0
      if num = 2 : return 1
      return 2
   .
   i = 3
   while i <= sqrt num
      if num mod i = 0 : return i
      i += 2
   .
   return 1
.
func brilliant n .
   f1 = factor n
   if f1 = 1 : return 0
   f2 = n div f1
   if floor log10 f1 <> floor log10 f2 : return 0
   if factor f1 = 1 and factor f2 = 1 : return 1
   return 0
.
proc main .
   i = 2
   while cnt < 100
      if brilliant i = 1
         cnt += 1
         write i & " "
      .
      i += 1
   .
   print "\n"
   i = 2
   cnt = 0
   mag = 1
   repeat
      if brilliant i = 1
         cnt += 1
         if i >= mag
            print i & " (" & cnt & ")"
            mag *= 10
         .
      .
      until mag = 10000000
      i += 1
   .
.
main

d[][] = [ [ 0 1 2 3 4 5 6 7 8 9 ] [ 1 2 3 4 0 6 7 8 9 5 ] [ 2 3 4 0 1 7 8 9 5 6 ] [ 3 4 0 1 2 8 9 5 6 7 ] [ 4 0 1 2 3 9 5 6 7 8 ] [ 5 9 8 7 6 0 4 3 2 1 ] [ 6 5 9 8 7 1 0 4 3 2 ] [ 7 6 5 9 8 2 1 0 4 3 ] [ 8 7 6 5 9 3 2 1 0 4 ] [ 9 8 7 6 5 4 3 2 1 0 ] ]
inv[] = [ 0 4 3 2 1 5 6 7 8 9 ]
p[][] = [ [ 0 1 2 3 4 5 6 7 8 9 ] [ 1 5 7 6 2 8 3 0 9 4 ] [ 5 8 0 3 7 9 6 1 4 2 ] [ 8 9 1 6 0 4 3 5 2 7 ] [ 9 4 5 3 1 2 6 8 7 0 ] [ 4 2 8 6 5 7 3 9 0 1 ] [ 2 7 9 3 8 0 6 4 1 5 ] [ 7 0 4 6 9 1 3 2 5 8 ] ]
#
func verhoeff s$ validate verbose .
   if verbose = 1
      t$ = "Check digit"
      if validate = 1 : t$ = "Validation"
      print t$ & " calculations for '" & s$ & "'\n"
      print " i  nᵢ  p[i,nᵢ]  c"
      print "------------------"
   .
   s$[] = strchars s$
   lng = len s$[]
   if validate = 1 : lng -= 1
   for i = lng downto 0
      ni = 0
      if i < lng or validate = 1 : ni = strcode s$[i + 1] - 48
      if ni < 0 or ni > 9 : print "error"
      pii = p[(lng - i) mod 8 + 1][ni + 1]
      c = d[c + 1][pii + 1]
      if verbose = 1 : print " " & lng - i & "  " & ni & "      " & pii & "     " & c
   .
   if verbose = 1 and validate = 0 : print "\ninv[" & c & "] = " & inv[c + 1]
   if validate = 1 : return if c = 0
   return inv[c + 1]
.
ss$[] = [ "236" "12345" "123456789012" ]
for i to 3
   s$ = ss$[i]
   verbose = if i <= 2
   c = verhoeff s$ 0 verbose
   print "\nThe check digit for '" & s$ & "' is '" & c & "'."
   sc$ = s$
   for j to 2
      if j = 1
         sc$ &= c
      else
         sc$ &= "9"
      .
      h$ = "incorrect"
      if verhoeff sc$ 1 verbose = 1 : h$ = "correct"
      print "\nThe validation for '" & sc$ & "' is " & h$ & "."
   .
.

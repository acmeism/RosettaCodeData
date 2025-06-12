proc adjacent txt$ n .
   print "n = " & n & ", width = " & len txt$
   print "input:  " & txt$
   txt$[] = strchars txt$
   res$[] = txt$[]
   for i to len res$[]
      if txt$[i] = "1"
         for j = i + 1 to lower (i + n) len res$[]
            res$[j] = "1"
         .
      .
   .
   res$ = strjoin res$[] ""
   print "result: " & res$
   print ""
.
adjacent "1000" 2
adjacent "0100" 2
adjacent "0010" 2
adjacent "0000" 2
test$ = "010000000000100000000010000000010000000100000010000010000100010010"
adjacent test$ 0
adjacent test$ 1
adjacent test$ 2
adjacent test$ 3

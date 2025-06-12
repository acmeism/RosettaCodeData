func calcpass passw$ nonce$ .
   start = 1
   passw = number passw$
   for c$ in strchars nonce$
      if c$ <> "0"
         if start = 1 : num2 = passw
         start = 0
      .
      if c$ = "1"
         num1 = bitshift bitand num2 0xFFFFFF80 -7
         num2 = bitshift num2 25
      elif c$ = "2"
         num1 = bitshift bitand num2 0xFFFFFFF0 -4
         num2 = bitshift num2 28
      elif c$ = "3"
         num1 = bitshift bitand num2 0xFFFFFFF8 -3
         num2 = bitshift num2 29
      elif c$ = "4"
         num1 = bitshift num2 1
         num2 = bitshift num2 -31
      elif c$ = "5"
         num1 = bitshift num2 5
         num2 = bitshift num2 -27
      elif c$ = "6"
         num1 = bitshift num2 12
         num2 = bitshift num2 -20
      elif c$ = "7"
         h1 = bitand num2 0x0000FF00
         h2 = bitshift bitand num2 0x000000FF 24
         h3 = bitshift bitand num2 0x00FF0000 -16
         num1 = bitor bitor h1 h2 h3
         num2 = bitshift bitand num2 0xFF000000 -8
      elif c$ = "8"
         num1 = bitor bitshift bitand num2 0x0000FFFF 16 bitshift num2 -24
         num2 = bitshift bitand num2 0x00FF0000 -8
      elif c$ = "9"
         num1 = bitnot num2
      else
         num1 = num2
      .
      if c$ <> "0" and c$ <> "9"
         num1 = bitor num1 num2
      .
      num2 = bitand 0xffffffff num1
   .
   return bitand 0xffffffff num1
.
proc test_passwd passwd$ nonce$ expected$ .
   res = calcpass passwd$ nonce$
   m$ = passwd$ & " " & nonce$ & " " & res & " " & expected$
   if res = number expected$
      print "PASS " & m$
   else
      print "FAIL " & m$
   .
.
test_passwd "12345" "603356072" "25280520"
test_passwd "12345" "410501656" "119537670"
test_passwd "12345" "630292165" "4269684735"

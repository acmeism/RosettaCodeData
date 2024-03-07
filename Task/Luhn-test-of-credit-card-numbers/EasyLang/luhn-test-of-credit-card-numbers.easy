func luhn cc$ .
   for i = len cc$ downto 1
      odd = 1 - odd
      dig = number substr cc$ i 1
      if odd = 0
         dig = 2 * dig
         if dig >= 10
            dig -= 9
         .
      .
      sum += dig
   .
   return if sum mod 10 = 0
.
cc$[] = [ "49927398716" "49927398717" "1234567812345678" "1234567812345670" ]
for cc$ in cc$[]
   write cc$ & " "
   if luhn cc$ = 1
      print "is valid"
   else
      print "is not valid"
   .
.

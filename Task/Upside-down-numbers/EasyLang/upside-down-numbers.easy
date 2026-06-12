list[] = [ 5 ]
listx[] = [ 19 28 37 46 55 64 73 82 91 ]
index = 1
ndig = 1
nextout = 500
print "First fifty upside-downs:"
while udcount < 5000000
   if index <= len list[]
      udn = list[index]
      udcount += 1
      if udcount <= 50
         write udn & " "
         if udcount = 50 : print "\n"
      elif udcount = nextout
         print udcount & "th : " & udn
         nextout *= 10
      .
      index += 1
   else
      nlist[] = [ ]
      ndig += 1
      for k to 9 : for t to len list[]
         nlist[] &= k * (pow 10 ndig) + 10 * list[t] + (10 - k)
      .
      swap list[] nlist[]
      index = 1
      swap list[] listx[]
   .
.

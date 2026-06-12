func ispal s$ .
   c$[] = strchars s$
   for i to len c$[] div 2
      if c$[i] <> c$[$ - i + 1] : return 0
   .
   return 1
.
for n = 100 to 125
   s$ = n
   write s$ & ": "
   if ispal substr s$ 1 3 = 1 : write s$ & " "
   for i to 2
      h$ = substr s$ i 2
      if h$ <> hp$ and ispal h$ = 1 : write h$ & " "
      hp$ = h$
   .
   for h$ in strchars s$
      if h$ <> hp$ and h$ <> hpp$ : write h$ & " "
      hpp$ = hp$
      hp$ = h$
   .
   print ""
.
print ""
data$[] = [ "9" "169" "12769" "1238769" "123498769" "12346098769" "1234572098769" "123456832098769" "12345679432098769" "1234567905432098769" "123456790165432098769" "83071934127905179083" "13202679478494903612056" ]
func test2 s$ .
   for i to len s$ - 1
      for j = 2 to len s$ - i + 1
         if ispal substr s$ i j = 1 : return 1
      .
   .
   return 0
.
for d$ in data$[] : if test2 d$ = 1 : print d$

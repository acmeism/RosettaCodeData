small$[] = [ "zero" "one" "two" "three" "four" "five" "six" "seven" "eight" "nine" "ten" "eleven" "twelve" "thirteen" "fourteen" "fifteen" "sixteen" "seventeen" "eighteen" "nineteen" ]
tens$[] = [ "" "" "twenty" "thirty" "forty" "fifty" "sixty" "seventy" "eighty" "ninety" ]
illions$[] = [ "" " thousand" " million" " billion" " trillion" " quadrillion" " quintillion" ]
func$ say n .
   if n < 0
      t$ = "negative "
      n = -n
   .
   if n < 20
      t$ &= small$[n + 1]
   elif n < 100
      t$ &= tens$[n div 10 + 1]
      s = n mod 10
      if s > 0
         t$ &= "-" & small$[s + 1]
      .
   elif n < 1000
      t$ &= small$[n div 100 + 1] & " hundred"
      s = n mod 100
      if s > 0
         t$ &= " " & say s
      .
   else
      i = 1
      while n > 0
         p = n mod 1000
         n = n div 1000
         if p > 0
            ix$ = say p & illions$[i]
            if sx$ <> ""
               ix$ &= " " & sx$
            .
            sx$ = ix$
         .
         i += 1
      .
      t$ &= sx$
   .
   return t$
.
irregularOrds$[] = [ "one" "first" "two" "second" "three" "third" "five" "fifth" "eight" "eighth" "nine" "ninth" "twelve" "twelfth" ]
func$ sayOrdinal n .
   s$ = say n
   s$[] = strchars s$
   for i = len s$[] downto 1
      if s$[i] = "-" or s$[i] = " " : break 1
   .
   s1$ = substr s$ 1 i
   s2$ = substr s$ (i + 1) 99999999
   for i = 1 step 2 to len irregularOrds$[]
      if irregularOrds$[i] = s2$ : break 1
   .
   if i < len irregularOrds$[]
      s$ = s1$ & irregularOrds$[i + 1]
   elif s$[$] = "y"
      s$ = substr s$ 1 (len s$[] - 1) & "ieth"
   else
      s$ &= "th"
   .
   return s$
.
for n in [ 1 2 3 4 5 11 65 100 101 272 23456 8007006005004003 ]
   print sayOrdinal n
.

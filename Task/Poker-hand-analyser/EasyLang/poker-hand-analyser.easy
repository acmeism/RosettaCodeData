func isstraight &h[][] &cnt[] .
   for i = 1 to 14
      cnt = cnt[i]
      if i = 1 and cnt[14] = 1 : cnt = 1
      if cnt = 1
         cons += 1
         if cons = 5 : return 1
      else
         cons = 0
      .
   .
   return 0
.
func isflush &h[][] .
   for i to 4
      if h[i + 1][2] <> h[i][2] : return 0
   .
   return 1
.
func isvalid &h[][] .
   for i to 5
      if h[i][1] = 1 or h[i][2] = 0 : return 0
   .
   for i = 1 to 5 : for j = i + 1 to 5
      if h[i][] = h[j][] : return 0
   .
   return 1
.
proc analyse &h[][] .
   len cnt[] 14
   for i to 5 : cnt[h[i][1]] += 1
   straight = isstraight h[][] cnt[]
   flush = isflush h[][]
   if isvalid h[][] = 0
      print "invalid"
   elif straight = 1 and flush = 1
      print "straight-flush"
   elif flush = 1
      print "flush"
   elif straight = 1
      print "straight"
   else
      for cnt in cnt[]
         if cnt = 2
            two += 1
         elif cnt = 3
            three += 1
         elif cnt = 4
            four += 1
         .
      .
      if four = 1
         print "four-of-a-kind"
      elif two = 1 and three = 1
         print "full-house"
      elif three = 1
         print "three-of-a-kind"
      elif two = 2
         print "two-pairs"
      elif two = 1
         print "one-pair"
      else
         print "high-card"
      .
   .
.
faces$ = "23456789TJQKA"
suites$ = "SHDC"
repeat
   s$ = input
   until s$ = ""
   write s$ & " : "
   card$[] = strtok s$ " "
   hand[][] = [ ]
   for c$ in card$[]
      a$[] = strchars c$
      f = strpos faces$ a$[1] + 1
      s = strpos suites$ a$[2]
      hand[][] &= [ f s ]
   .
   analyse hand[][]
.
input_data
2H 2D 2S KS QD
2H 5H 7D 8S 9D
AH 2D 3S 4S 5S
2H 3H 2D 3S 3D
2H 7H 2D 3S 3D
2H 7H 7D 7S 7C
TH JH QH KH AH
4H 4C KC 5D TC
QC TC 7C 6C 4C
QC TC 7C 6C QC

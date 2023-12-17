attr$[][] &= [ "one  " "two  " "three" ]
attr$[][] &= [ "solid  " "striped" "open   " ]
attr$[][] &= [ "red   " "green " "purple" ]
attr$[][] &= [ "diamond" "oval" "squiggle" ]
#
subr init
   for card = 0 to 80
      pack[] &= card
   .
.
proc card2attr card . attr[] .
   attr[] = [ ]
   for i to 4
      attr[] &= card mod 3 + 1
      card = card div 3
   .
.
proc printcards cards[] . .
   for card in cards[]
      card2attr card attr[]
      for i to 4
         write attr$[i][attr[i]] & " "
      .
      print ""
   .
   print ""
.
proc getsets . cards[] set[] .
   set[] = [ ]
   for i to len cards[]
      card2attr cards[i] a[]
      for j = i + 1 to len cards[]
         card2attr cards[j] b[]
         for k = j + 1 to len cards[]
            card2attr cards[k] c[]
            ok = 1
            for at to 4
               s = a[at] + b[at] + c[at]
               if s <> 3 and s <> 6 and s <> 9
                  ok = 0
               .
            .
            if ok = 1
               set[] &= cards[i]
               set[] &= cards[j]
               set[] &= cards[k]
            .
         .
      .
   .
.
proc run ncards nsets . .
   #
   repeat
      init
      cards[] = [ ]
      for i to ncards
         ind = random len pack[]
         cards[] &= pack[ind]
         pack[ind] = pack[len pack[]]
         len pack[] -1
      .
      getsets cards[] set[]
      until len set[] = 3 * nsets
   .
   print "Cards:"
   printcards cards[]
   print "Sets:"
   for i = 1 step 3 to 3 * nsets - 2
      printcards [ set[i] set[i + 1] set[i + 2] ]
   .
.
run 9 4
print " --------------------------"
run 12 6

proc tonext &dig[] &digind[] &ok .
   for i = len dig[] downto 1
      d = dig[i]
      digind[d] = 0
      repeat
         d += 1
         until digind[d] = 0
      .
      if d < 10
         dig[i] = d
         digind[d] = i
         for j = i + 1 to len dig[]
            d = 0
            repeat
               d += 1
               until digind[d] = 0
            .
            dig[j] = d
            digind[d] = j
         .
         ok = 1
         return
      .
   .
   ok = 0
.
#
func rmdig digs[] idx .
   for i to len digs[]
      if i <> idx : sum = sum * 10 + digs[i]
   .
   return sum
.
func digv digs[] .
   for i to len digs[] : sum = sum * 10 + digs[i]
   return sum
.
proc main .
   for digcnt = 2 to 4
      ndigs[] = [ ]
      for i to digcnt : ndigs[] &= i
      ndigind[] = [ 0 0 0 0 0 0 0 0 0 0 ]
      for i to len ndigs[] : ndigind[ndigs[i]] = i
      len rdigv[] digcnt
      omitted[] = [ 0 0 0 0 0 0 0 0 0 ]
      cnt = 0
      repeat
         nv = digv ndigs[]
         for i to digcnt : rdigv[i] = rmdig ndigs[] i
         ddigs[] = ndigs[]
         ddigind[] = ndigind[]
         repeat
            tonext ddigs[] ddigind[] ok
            until ok = 0
            dv = digv ddigs[]
            for nix to len ndigs[]
               dig = ndigs[nix]
               dix = ddigind[dig]
               if dix > 0
                  rnv = rdigv[nix]
                  rdv = rmdig ddigs[] dix
                  if nv / dv = rnv / rdv
                     cnt += 1
                     omitted[dig] += 1
                     if cnt <= 12
                        print nv & "/" & dv & " = " & rnv & "/" & rdv & " by omitting " & dig & "'s"
                     .
                  .
               .
            .
         .
         tonext ndigs[] ndigind[] ok
         until ok = 0
      .
      print digcnt & "-digit fractions: " & cnt
      print "Omitted digits: " & omitted[]
      print ""
   .
.
main

nr = 0
gapful1 = 99
gapful2 = 999999
gapful3 = 999999999
limit1 = 30
limit2 = 15
limit3 = 10

see "First 30 gapful numbers >= 100:" + nl
while nr < limit1
      gapful1 = gapful1 + 1
      gap1 = left((string(gapful1)),1)
      gap2 = right((string(gapful1)),1)
      gap = number(gap1 +gap2)
      if gapful1 % gap = 0
         nr = nr + 1
         see "" + nr + ". " + gapful1 + nl
      ok
end
see nl

see "First 15 gapful numbers >= 1000000:" + nl
nr = 0
while nr < limit2
      gapful2 = gapful2 + 1
      gap1 = left((string(gapful2)),1)
      gap2 = right((string(gapful2)),1)
      gap = number(gap1 +gap2)
      if (nr < limit2) and gapful2 % gap = 0
         nr = nr + 1
         see "" + nr + ". " + gapful2 + nl
      ok
end
see nl

see "First 10 gapful numbers >= 1000000000:" + nl
nr = 0
while nr < limit3
      gapful3 = gapful3 + 1
      gap1 = left((string(gapful3)),1)
      gap2 = right((string(gapful3)),1)
      gap = number(gap1 +gap2)
      if (nr < limit2) and gapful3 % gap = 0
         nr = nr + 1
         see "" + nr + ". " + gapful3 + nl
      ok
end

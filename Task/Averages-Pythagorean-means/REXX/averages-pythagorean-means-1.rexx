-- 25 Jun 2026
include Setting

say 'PYTHAGORAN MEANS'
say version
say
l=MakeL(10,'A')
a=AmeanL(l); g=GmeanL(l); h=HmeanL(l)
say 'Used list       =' List2form(l)
say 'Arithmetic mean =' A
say 'Geometric mean  =' G
say 'Harmonic mean   =' H
say 'A>=G>=H         =' (a>=g & g>=h)
exit

-- AmeanL GmeanL HmeanL MakeL
include Math

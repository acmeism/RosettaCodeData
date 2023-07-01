   HQ=: cells i.($map)#.11 11 NB. HQ as a graph index
   \:~ ~. HQ{graph NB. all path lengths starting at HQ
_ 6 5 4 3 2 1
   ($map)#:cells{~I._=HQ{graph NB. can't get there from HQ
 2 18
 4  3
18 20
   ($map)#:cells{~I.6=HQ{graph NB. 6 days from HQ
 3 19
 6 20
17 20
20 14
22 12

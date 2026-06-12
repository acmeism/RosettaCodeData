alfa=: 'ABCDEFGHIKLMNOPQRSTUWXYZ'
beta=: 26{.(}.~i.&'A')a.
norm=: ([ -. -.)&alfa@(rplc&('JIVU'))@toupper
enca=:(5#2),@:#:alfa i. norm
gena=: ]`((,:tolower)@(beta {~ 26 ?@#~ #))}

encrypt=: gena@enca@norm
decrypt=: alfa {~ _5 #.\ 90 < a.&i.

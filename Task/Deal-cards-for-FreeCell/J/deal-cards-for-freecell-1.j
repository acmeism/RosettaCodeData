deck=: ,/ 'A23456789TJQK' ,"0/ 7 u: '♣♦♥♠'

srnd=: 3 :'SEED=:{.y,11982'
srnd ''
seed=: do bind 'SEED'
rnd=: (2^16) <.@%~ (2^31) srnd@| 2531011 + 214013 * seed

pairs=: <@<@~.@(<: , (| rnd))@>:@i.@-@#  NB. indices to swap, for shuffle
swaps=: [: > C.&.>/@|.@;  NB.                implement the specified shuffle
deal=: |.@(swaps pairs) bind deck

show=: (,"2)@:(_8 ]\ ' '&,.)

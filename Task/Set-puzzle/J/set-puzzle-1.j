require 'stats/base'

Number=: ;:'one two three'
Colour=: ;:'red green purple'
Fill=: ;:'solid open striped'
Symbol=: ;:'oval squiggle diamond'
Features=: Number ; Colour ; Fill ;< Symbol
Deck=: > ; <"1 { i.@#&.> Features
sayCards=: (', ' joinstring Features {&>~ ])"1
drawRandom=: ] {~ (? #)
isSet=: *./@:(1 3 e.~ [: #@~."1 |:)"2
getSets=:  ([: (] #~ isSet) ] {~ 3 comb #)
countSets=: #@:getSets

set_puzzle=: verb define
 target=. <. -: y
 whilst. target ~: countSets Hand do.
   Hand=. y drawRandom Deck
 end.
 echo 'Dealt ',(": y),' Cards:'
 echo sayCards Hand
 echo 'Found ',(":target),' Sets:'
 echo sayCards getSets Hand
)

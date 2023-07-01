shuffle =: {~ ?~@:#
f =: (,&.> {:)~
g =: ({.@],(f {:))`((f {.),{:@])@.({.@[)

trick =: 3 :0
 DECK =: shuffle 2 | i. 52
 'B R' =: shuffle L:_1 > g&.>/(_2 <\ DECK) , < 2 # a:
 NB. although I swap the first N cards of each pile,
 NB. the piles were shuffled following placement
 N =: ? R <.&# B
 echo 'prior to swap of ',(":N),' cards'
 echo 'black pile ',B{'rB'
 echo 'red pile   ',R{'rB'
 BR =: N {. B
 RB =: N {. R
 B =: RB , N }. B
 R =: BR , N }. R
 echo 'after swap'
 echo 'black pile ',B{'rB'
 echo 'red pile   ',R{'rB'
 B (-:&(+/) -.) R
)


   assert trick''
prior to swap of 10 cards
black pile rBrrrrrBBrrrBrr
red pile   BBrBrBBrBBr
after swap
black pile BBrBrBBrBBrrBrr
red pile   rBrrrrrBBrr

   assert trick''
prior to swap of 6 cards
black pile rBBBBrBBr
red pile   rrBBBBrBrBBBBrrBB
after swap
black pile rrBBBBBBr
red pile   rBBBBrrBrBBBBrrBB

   assert trick''
prior to swap of 3 cards
black pile rBrBrrrBBrr
red pile   BrrBrBBrBBBBBBB
after swap
black pile BrrBrrrBBrr
red pile   rBrBrBBrBBBBBBB

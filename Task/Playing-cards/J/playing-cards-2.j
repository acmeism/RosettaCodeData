   load '~user/playingcards.ijs'
   coinsert 'rcpc'              NB. insert rcpc class in the path of current locale
   pc=: newDeck ''
   $TheDeck__pc
52 2
   shuffle__pc ''
1
   sayCards 2 dealCards__pc 5   NB. deal two hands of five cards
 3♦
 4♦
 K♠
 A♦
 K♦

 5♠
10♣
 Q♥
 2♣
 9♣
   $TheDeck__pc                 NB. deck size has been reduced by the ten cards dealt
42 2
   destroy__pc ''
1

(de *Suits
   Club Diamond Heart Spade )

(de *Pips
   Ace 2 3 4 5 6 7 8 9 10 Jack Queen King )

(de mkDeck ()
   (mapcan
      '((Pip) (mapcar cons *Suits (circ Pip)))
      *Pips ) )

(de shuffle (Lst)
   (by '(NIL (rand)) sort Lst) )

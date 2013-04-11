/*REXX pgm shows methods (subroutines) to build/shuffle/deal a card deck*/
call buildDeck  ; say '     new deck:'  newDeck       /*new 52-card deck*/
call shuffleDeck; say 'shuffled deck:'  theDeck       /*shuffled deck.  */
call dealHands 5,4                                    /*5 cards, 4 hands*/
say;   say;   say right('[north]'  hand.1,50)
       say;   say       '[west]'   hand.4       right('[east]'  hand.2,60)
       say;   say right('[south]'  hand.3,50)
say;   say;   say;   say 'remainder of deck:'  theDeck
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────BUILDDECK subroutine────────────────*/
buildDeck:  _='';     ranks='A 2 3 4 5 6 7 8 9 10 J Q K'       /*ranks. */
if 1=='f1'x then suits='h d c s'                               /*EBCDIC?*/
            else suits='♥ ♦ ♣ ♠'                               /*ASCII. */
                                   do   s=1  for words(suits)
                                     do r=1  for words(ranks)
                                     _=_  word(ranks,r)word(suits,s)
                                     end   /*dealR*/
                                   end;    /*dealS*/           newDeck=_
return
/*──────────────────────────────────SHUFFLEDECK subroutine──────────────*/
shuffleDeck:  theDeck='';     _=newDeck;     #cards=words(_)
         do shuffler=1  for #cards     /*shuffle all the cards in deck. */
         r=random(1,#cards+1-shuffler) /*random #  decreases each time. */
         theDeck=theDeck  word(_,r)    /*sufffled deck, 1 card at-a-time*/
         _=delword(_,r,1)              /*delete the just-chosen card.   */
         end   /*shuffler*/
return
/*──────────────────────────────────DEALHANDS subroutine────────────────*/
dealHands:  parse arg numberOfCards,hands;     hand.=''
        do numberOfCards               /*deal the hand to the players.  */
          do player=1  for hands       /*deal a card to the players.    */
          hand.player=hand.player subword(theDeck,1,1)  /*deal top card.*/
          theDeck=subword(theDeck,2 )  /*diminish deck, remove one card.*/
          end   /*player*/
        end     /*numberOfCards*/
return

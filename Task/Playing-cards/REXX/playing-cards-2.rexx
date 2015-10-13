/*REXX pgm shows a method to build/shuffle/deal a standard 52─card deck.*/
box =  build();   say ' box of cards:'  box     /*a new box of 52─cards.*/
deck=shuffle();   say 'shuffled deck:'  deck    /*randomly shuffled deck*/
call deal  5, 4   /* ◄═════════════════════════════════ 5 cards, 4 hands*/
say;   say;   say right('[north]'  hand.1,50)
       say;   say       '[west]'   hand.4       right('[east]'  hand.2,60)
       say;   say right('[south]'  hand.3,50)
say;   say;   say;   say 'remainder of deck: '  deck
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────BUILD subroutine────────────────────*/
build:  _=;       ranks= "A 2 3 4 5 6 7 8 9 10 J Q K"         /*ranks.  */
if 5=='f5'x  then suits= "h d c s"                            /*EBCDIC? */
             else suits= "♥ ♦ ♣ ♠"                            /*ASCII.  */
#ranks=words(ranks);           do   s=1  for words(suits); @=word(suits,s)
                                 do r=1  for #ranks
                                 _=_ word(ranks,r)@
                                 end   /*s*/
                               end     /*r*/
return _
/*──────────────────────────────────SHUFFLE subroutine──────────────────*/
shuffle:           y=;  _=box;   #cards=words(_)     /*define REXX vars.*/
         do shuffler=1  for #cards     /*shuffle all the cards in deck. */
         ?=random(1,#cards+1-shuffler) /*each shuffle, random# decreases*/
         y=y  word(_, ?)               /*shuffled deck, 1 card at─a─time*/
         _=delword(_, ?, 1)            /*delete the  just─chosen  card. */
         end   /*shuffler*/
return y
/*──────────────────────────────────DEAL subroutine─────────────────────*/
deal:                            parse arg #cards, hands;           hand.=
         do   #cards                   /*deal the hand to the players.  */
           do player=1  for hands      /*deal some cards to the players.*/
           hand.player=hand.player  word(deck, 1)       /*deal top card.*/
           deck=subword(deck, 2)       /*diminish deck, remove one card.*/
           end   /*player*/
         end     /*#cards*/
return

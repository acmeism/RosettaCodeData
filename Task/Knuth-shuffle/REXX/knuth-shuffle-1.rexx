/*REXX program shuffles a deck of playing cards using the Knuth shuffle.*/
rank='A 2 3 4 5 6 7 8 9 10 J Q K'      /*pips  of the playing cards.    */
suit='♣♠♦♥'                            /*suit   "  "     "      "       */
parse arg seed .; if seed\=='' then call random ,,seed  /*repeatability?*/
say '────────────────── getting a new deck out of the box ···'
deck.1='highJoker'                     /*good decks have a color joker, */
deck.2='lowJoker'                      /*··· and a black & white joker. */
cards=2                                /*now, two cards are in the deck.*/
               do j     =1  for length(suit)
                    do k=1  for words(rank);            cards=cards+1
                    deck.cards=substr(suit,j,1)word(rank,k)
                    end  /*k*/
               end       /*j*/
call showDeck
say '────────────────── shuffling' cards "cards ···"
     do s=cards  by -1  to 2;            rand=random(1,s)
     parse value   deck.rand   deck.s    with     deck.s  deck.rand
                                       /* [↑] swap two cards in the deck*/
     end   /*s*/
call showDeck
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────SHOWDECK subroutine─────────────────*/
showDeck: _=;  do m=1 for cards; _=_ deck.m; end /*m*/; say _; say; return

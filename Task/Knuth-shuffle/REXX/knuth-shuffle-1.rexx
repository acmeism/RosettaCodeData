/*REXX program shuffles a deck of playing cards (with jokers)  using the  Knuth shuffle.*/
rank= 'A 2 3 4 5 6 7 8 9 10 J Q K'               /*pips  of the various playing cards.  */
suit= '♣♠♦♥'                                     /*suit   "  "     "       "      "     */
parse arg seed .                                 /*obtain optional argument from the CL.*/
if datatype(seed,'W')  then call random ,,seed   /*maybe use for  RANDOM  repeatability.*/
say '══════════════════ getting a new deck out of the box ···'
@.1= 'highJoker'                                 /*good decks have a color joker, and a */
@.2= 'lowJoker'                                  /*            ··· black & white joker. */
cards=2                                          /*now, there're 2 cards are in the deck*/
               do j     =1  for length(suit)
                    do k=1  for  words(rank);      cards=cards + 1
                    @.cards=substr(suit, j, 1)word(rank, k)
                    end  /*k*/
               end       /*j*/
call show
say;      say '══════════════════ shuffling' cards "cards ···"
     do s=cards  by -1  to 2;  ?=random(1,s);  parse value  @.?  @.s   with   @.s  @.?
                                                 /*  [↑]  swap two cards in the deck.   */
     end   /*s*/
call show
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
show: _=;      do m=1  for cards;   _=_ @.m;   end  /*m*/;         say _;           return

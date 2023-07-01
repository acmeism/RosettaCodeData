/*REXX program shuffles a deck of playing cards (with jokers)  using the  Knuth shuffle.*/
rank = 'ace deuce trey 4 5 6 7 8 9 10 jack queen king'         /*use pip names for cards*/
suit = 'club spade diamond heart'                              /* "  suit  "    "    "  */
say '══════════════════ getting a new deck out of the box ···'
@.1= '  color joker'                             /*good decks have a color joker, and a */
@.2= '    b&w joker'                             /*            ··· black & white joker. */
cards=2                                          /*now, there're 2 cards are in the deck*/
          do j     =1  for words(suit)
               do k=1  for words(rank);       cards=cards+1    /*bump the card counter. */
               @.cards=right(word(suit,j),7)  word(rank,k)     /*assign a card name.    */
               end  /*k*/
          end       /*j*/

call show 'ace'                                  /*inserts blank when an  ACE  is found.*/
say;  say '══════════════════ shuffling' cards "cards ···"

          do s=cards  by -1  to 2;   ?=random(1,s);   _=@.?;   @.?=@.s;    @.s=_
          end   /*s*/                            /* [↑]  swap two cards in the deck.    */
call show
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
show: parse arg break;    say                    /*get separator card, show blank line. */
        do m=1  for cards                        /* [↓]  traipse through the card deck. */
        if pos(break,@.m)\==0  then say          /*show a blank to read cards easier.   */
        say 'card'  right(m, 2)    '───►'   @.m  /*display a particular card from deck. */
        end   /*m*/
return

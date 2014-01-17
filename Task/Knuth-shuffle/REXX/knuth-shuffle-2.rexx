/*REXX program shuffles a deck of playing cards using the Knuth shuffle.*/
rank = 'ace deuce trey 4 5 6 7 8 9 10 jack queen king'  /*use pip names.*/
suit = 'club spade diamond heart'                       /* "  suit   "  */
say '────────────────── getting a new deck out of the box ···'
deck.1 = '  color joker'               /*good decks have a color joker, */
deck.2 = '    b&w joker'               /*··· and a black & white joker. */
cards=2                                /*now, two cards are in the deck.*/
          do j     =1  for words(suit)
               do k=1  for words(rank);  cards=cards+1   /*bump counter.*/
               deck.cards=right(word(suit,j),7)  word(rank,k)  /*assign.*/
               end  /*k*/
          end       /*j*/

call showDeck 'ace'                    /*inserts blank when ACE is found*/
say '────────────────── shuffling' cards "cards ···"

  do s=cards  by -1  to 2; rand=random(1,s) /*get random number for swap*/
  _=deck.rand; deck.rand=deck.s; deck.s=_   /*swap 2 cards in card deck.*/
  end   /*s*/

call showDeck
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────SHOWDECK subroutine─────────────────*/
showDeck: parse arg break;    say       /*get sep card, shows blank line*/
    do m=1  for cards                   /*traipse through the deck.     */
    if pos(break,deck.m)\==0  then say  /*a blank: easier to read cards.*/
    say 'card' right(m,2) '───►' deck.m /*display a particular card.    */
    end   /*m*/
say                                     /*show a trailing blank line.   */
return

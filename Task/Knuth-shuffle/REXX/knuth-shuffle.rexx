/*REXX program shuffles a deck of playing cards using the Knuth shuffle.*/
rank='ace duece trey 4 5 6 7 8 9 10 jack queen king'
suit='club spade diamond heart'
say '────────────────── getting a new deck out of the box...'
deck.1='  color joker'                 /*good decks have a color joker, */
deck.2='    b&w joker'                 /*∙∙∙ and a black & white joker. */
cards=2                                /*now, two cards are in the deck.*/
           do j     =1  for words(suit)
                do k=1  for words(rank)
                cards=cards+1
                deck.cards=right(word(suit,j),7)  word(rank,k)
                end  /*k*/
           end       /*j*/

call showDeck 'ace'                    /*inserts blank when ACE is found*/
say '────────────────── shuffling' cards "cards..."

   do s=cards  by -1  to 1;            rand=random(1,s)
   if rand\==s  then do                /*swap two cards in the card deck*/
                     _=deck.rand
                     deck.rand=deck.s
                     deck.s=_
                     end
   end   /*s*/

call showDeck
say '────────────────── ready to play schafkopf  (take out jokers first).'
exit                                   /*stick a fork in it, we're done.*/

/*──────────────────────────────────SHOWDECK subroutine─────────────────*/
showDeck: parse arg break;    say
      do m=1  for cards
      if pos(break,deck.m)\==0  then say   /*blank, easier to read cards*/
      say 'card' right(m,2) '───►' deck.m
      end   /*m*/
say
return

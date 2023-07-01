/*REXX pgm shows a method to build/shuffle/deal 5 cards (using a 52─card deck)──►4 hands*/
box = build();   say ' box of cards:'   box      /*a brand new standard box of 52 cards.*/
deck= mix();     say 'shuffled deck:'   deck     /*obtain a randomly shuffled deck.     */
call deal  5, 4                                  /* ◄───────────────── 5 cards, 4 hands.*/
say;    say;     say right('[north]'   hand.1, 60)
        say;     say '      [west]'    hand.4             right('[east]'   hand.2, 60)
        say;     say right('[south]'   hand.3, 60)
say;    say;     say;    say 'remainder of deck: '        deck
exit 0                                           /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
build: _=;    ranks= "A 2 3 4 5 6 7 8 9 10 J Q K"                             /*ranks.  */
       if 5=='f5'x  then suits= "h d c s"                                     /*EBCDIC? */
                    else suits= "♥ ♦ ♣ ♠"                                     /*ASCII.  */
          do    s=1  for words(suits);    $=   word(suits, s)
             do r=1  for words(ranks);    _= _ word(ranks, r)$   /*append a suit to rank*/
             end   /*r*/
          end      /*s*/;                 return _               /*jokers are not used. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
deal: parse arg #cards, hands;            hand.=      /*initially,  nullify all hands.  */
          do   #cards                                 /*deal a hand to all the players. */
             do player=1  for hands                   /*deal some cards to the players. */
             hand.player= hand.player  word(deck, 1)  /*deal the top card to a player.  */
             deck= subword(deck, 2)                   /*diminish deck, elide one card.  */
             end   /*player*/
          end      /*#cards*/;            return
/*──────────────────────────────────────────────────────────────────────────────────────*/
mix: @=;      _=box;      #cards= words(_)            /*define three REXX variables.    */
          do mixer=1  for #cards                      /*shuffle all the cards in deck.  */
          ?= random(1, #cards + 1 - mixer)            /*each shuffle, random# decreases.*/
          @= @  word(_, ?)                            /*shuffled deck, 1 card at a time.*/
          _= delword(_, ?, 1)                         /*elide just─chosen card from deck*/
          end   /*mixer*/;                return @

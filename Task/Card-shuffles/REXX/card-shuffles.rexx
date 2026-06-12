/*REXX program simulates various types of shuffling a deck of cards  (any kind of deck).*/
call create;  call show  'new deck'              /*build and display a new card deck.   */

call create;  call riffle     1                  /*invoke a riffle shuffle  (N times).  */
              call show  'riffle shuffle'        /*display the results from last shuffle*/

call create;  call overhand  1/5                 /*invoke overhand shuffle with 20% cuts*/
              call show  'overhand shuffle'      /*display the results from last shuffle*/

call create;  call barnYard  13                  /*also called a washing machine shuffle*/
              call show  'barn yard shuffle'     /*display the results from last shuffle*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
create: if 9=='f9'x  then suit= "cdhs"           /*EBCDIC?   Then use letters for suits.*/
                     else suit= "♣♦♥♠"           /* ASCII?     "   "  symbols  "    "   */
        jokers= 0                                /*number of jokers in the card deck.   */
        wild= copies("jH jL", jokers)            /*a large # of high jokers, low jokers.*/
        rank= 'A23456789tJQK'                    /*t  in the rank represents a ten (10).*/
        decks= 1                                 /*the number of decks, building a shoe?*/
        $=                                       /*the initial (null) card deck (string)*/
               do   s=1  for length(suit)        /*process each of the card deck suits. */
               _= substr(suit, s, 1)             /*extract a single suit to build + pips*/
                 do r=1  for length(rank)        /*process each of the card deck pips.  */
                 $= $  _ || substr(rank, r, 1)   /*build a card, then append it to deck.*/
                 end   /*r*/                     /*Note: some decks have more pips, >13.*/
               end     /*s*/                     /*  "     "    "     "    "  suits, >4.*/
        $= space($  subword(wild, 1, jokers) )   /*keep a new card deck for each shuffle*/
        $= copies($, decks)                      /*maybe build multiple decks for a shoe*/
        #= words($)                              /*set the number of cards in the deck. */
                                                 /*another entry point for this function*/
build:  @.=;         do j=1  for words($)        /*build an array for the card deck.    */
                     @.j= word($, j)             /*construct an card from the deck list.*/
                     end   /*j*/
        return $                                 /*elide the leading blank in the deck. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
?:        return random(1, word( arg(1) #, 1) )  /*gen a random number from  1 ──► arg. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
barnYard:   do j=1  for arg(1);       x=?();
              do until y\==x | #<2;   y=?()
              end   /*until*/
            parse value   @.x  @.y     with     @.y  @.x
            end     /*j*/;                                           return
/*──────────────────────────────────────────────────────────────────────────────────────*/
riffle:   $A= subword($, 1, #%2);     $B= subword($, #%2 + 1);   $= /*split deck in half*/
            do j=1  for max( words($A), words($B) );       $= $  word($A, j)   word($B, j)
            end   /*j*/
          $= space($);   call build;                                 return
/*──────────────────────────────────────────────────────────────────────────────────────*/
overhand: parse arg pc .;  if pc==''  then pc= 1/5;   chunk= # * pc % 1;       $B=
            do while words($)\==0;    $B= $B subword($, 1, chunk); $= subword($, chunk +1)
            end   /*while*/
          $= space($B);               call build;                    return
/*──────────────────────────────────────────────────────────────────────────────────────*/
show:     _=@.1;        do j=2  for #-1;   _=_ @.j;   end /*j*/;           L = length(_)
          say center( arg(1), L, '═');     say _;     say;           return  /*show deck*/

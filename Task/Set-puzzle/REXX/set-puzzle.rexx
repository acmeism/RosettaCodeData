/*REXX program  finds and displays  "sets" (solutions)  for the   SET  puzzle   (game). */
parse arg game seed .                            /*get optional # cards to deal and seed*/
if game=='' | game==","  then game=  9           /*Not specified?  Then use the default.*/
if seed=='' | seed==","  then seed= 77           /* "      "         "   "   "      "   */
call aGame 0                                     /*with tell=0:    suppress the output. */
call aGame 1                                     /*with tell=1:    display   "     "    */
exit sets                                        /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
aGame: parse arg tell;         good= game % 2    /*enable/disable the showing of output.*/
                                                 /* [↑]  the GOOD var is the right #sets*/
                 do seed=seed  until good==sets  /*generate deals until good  # of sets.*/
                 call random ,,seed              /*repeatability for the RANDOM invokes.*/
                 call genFeatures                /*generate various card game features. */
                 call genDeck                    /*    "    a deck  (with  81  "cards").*/
                 call dealer   game              /*deal a number of cards for the game. */
                 call findSets game%2            /*find # of sets from the dealt cards. */
                 end   /*until*/                 /* [↓]   when leaving, SETS is right #.*/
       return                                    /*return to invoker of this subroutine.*/
/*──────────────────────────────────────────────────────────────────────────────────────*/
dealer: call sey  'dealing'  game  "cards:", , . /*shuffle and deal the cards.          */

           do cards=1  until cards==game         /*keep dealing until finished.         */
           _= random(1, words(##) )              /*pick   a card.                       */
           ##= delword(##, _, 1)                 /*delete "   "                         */
           @.cards= deck._                       /*add the card to the tableau.         */
           call sey right('card' cards, 30) " " @.cards    /*display a card to terminal.*/

               do j=1  for words(@.cards)        /* [↓]  define cells for cards.        */
               @.cards.j= word(@.cards, j)       /*define  a  cell for  a card.         */
               end   /*j*/
           end       /*cards*/

        return
/*──────────────────────────────────────────────────────────────────────────────────────*/
defFeatures: parse arg what,v;   _= words(v)     /*obtain what is to be defined.        */

             if _\==values  then do;  call sey 'error,'  what  "features ¬=" values, ., .
                                      exit -1
                                 end             /* [↑]  check for typos and/or errors. */

               do k=1  for words(values)         /*define all the possible values.      */
               call value what'.'k,  word(values, k)         /*define  a  card feature. */
               end   /*k*/

             return
/*──────────────────────────────────────────────────────────────────────────────────────*/
findSets: parse arg n;   call genPoss            /*N:  the number of sets to be found.  */
          call sey                               /*find any sets that were generated [↑]*/

              do         j=1  for p              /*P:  is the number of possible sets.  */
                  do     f=1  for features
                      do g=1  for groups;     !!.j.f.g= word(!.j.f, g)
                      end   /*g*/
                  end       /*f*/

              ok= 1                              /*everything is peachy─kean (OK) so far*/

                  do g=1  for groups
                  _= !!.j.1.g                    /*build strings to hold possibilities. */
                  equ= 1                         /* [↓]  handles all the equal features.*/

                         do f=2  to features  while equ;     equ= equ  &  _==!!.j.f.g
                         end   /*f*/

                  dif= 1
                  __= !!.j.1.g                   /* [↓]  handles all  unequal  features.*/
                                      do f=2  to  features  while  \equ
                                      dif= dif &  (wordpos(!!.j.f.g, __)==0)
                                      __= __  !!.j.f.g  /*append to string for next test*/
                                      end   /*f*/

                  ok=ok & (equ | dif)            /*now, see if all are equal or unequal.*/
                  end   /*g*/

              if \ok  then iterate               /*Is this set OK?   Nope, then skip it.*/
              sets= sets + 1                     /*bump the number of the sets found.   */
              call sey  right('set'  sets":  ", 15)    !.j.1    sep   !.j.2    sep   !.j.3
              end   /*j*/

          call sey  sets   'sets found.', .
          return
/*──────────────────────────────────────────────────────────────────────────────────────*/
genDeck: #= 0;   ##=                             /*#:  cards in deck;  ##:  shuffle aid.*/

                       do         num=1  for values;         xnum = word(numbers,  num)
                          do      col=1  for values;         xcol = word(colors,   col)
                             do   sym=1  for values;         xsym = word(symbols,  sym)
                               do sha=1  for values;         xsha = word(shadings, sha)
                               #= # + 1;  ##= ## #;
                               deck.#= xnum  xcol  xsym  xsha          /*create a card. */
                               end   /*sha*/
                            end      /*num*/
                          end        /*sym*/
                       end           /*col*/

         return                                  /*#:  the number of cards in the deck. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
genFeatures: features= 3;  groups= 4;  values= 3 /*define # features, groups, values.   */
             numbers = 'one two three'           ;    call defFeatures 'number',  numbers
             colors  = 'red green purple'        ;    call defFeatures 'color',   colors
             symbols = 'oval squiggle diamond'   ;    call defFeatures 'symbol',  symbols
             shadings= 'solid open striped'      ;    call defFeatures 'shading', shadings
             return
/*──────────────────────────────────────────────────────────────────────────────────────*/
genPoss: p= 0;   sets= 0;   sep=' ───── '        /*define some REXX variables.          */
         !.=
                    do       i=1    for game     /* [↓]  the  IFs  eliminate duplicates.*/
                       do    j=i+1  to  game
                          do k=j+1  to  game
                          p= p + 1;          !.p.1= @.i;       !.p.2= @.j;      !.p.3= @.k
                          end   /*k*/
                       end      /*j*/
                    end         /*i*/            /* [↑]  generate the permutation list. */

         return
/*──────────────────────────────────────────────────────────────────────────────────────*/
sey:  if \tell  then  return                     /*¬ tell?    Then suppress the output. */
      if arg(2)==.  then say;      say arg(1);      if arg(3)==.  then say;         return

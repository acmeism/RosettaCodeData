/*REXX program performs a  "perfect shuffle"  for a number of  even numbered  decks.    */
parse arg X                                      /*optional list of test cases from C.L.*/
if X=''  then X=8 24 52 100 1020 1024 10000      /*Not specified?  Then use the default.*/
w=length(word(X, words(X)))                      /*used for right─aligning the numbers. */

    do j=1  for words(X);  y=word(X,j)           /*use numbers in the test suite (list).*/

      do k=1  for y;       @.k=k;      end /*k*/ /*generate a deck to be used (shuffled)*/
      do t=1  until eq();  call magic; end /*t*/ /*shuffle until  before  equals  after.*/

    say 'deck size:'    right(y,w)","       right(t,w)      'perfect shuffles.'
    end   /*j*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
eq:    do ?=1  for y;   if @.?\==?  then return 0;   end;           return 1
/*──────────────────────────────────────────────────────────────────────────────────────*/
magic: z=0                                       /*set the  Z  pointer  (used as index).*/
       h=y%2                                     /*get the half─way (midpoint) pointer. */
                do s=1  for h;  z=z+1;  h=h+1    /*traipse through the card deck pips.  */
                !.z=@.s;        z=z+1            /*assign left half; then bump pointer. */
                !.z=@.h                          /*   "   right  "                      */
                end   /*s*/                      /*perform a perfect shuffle of the deck*/

                do r=1  for y;  @.r=!.r;  end    /*re─assign to the original card deck. */
       return

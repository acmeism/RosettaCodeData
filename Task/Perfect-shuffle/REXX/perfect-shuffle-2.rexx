/*REXX program does a  "perfect shuffle"  for a number of  even  numbered  decks.       */
parse arg X                                      /*optional list of test cases from C.L.*/
if X=''  then X=8 24 52 100 1020 1024 10000      /*Not specified?  Use default.*/
w=length(word(X, words(X)))                      /*used for right─aligning the numbers. */

    do j=1  for words(X);  y=word(X,j)           /*use numbers in the test suite (list).*/

      do k=1  for y;       @.k=k;       end      /*generate a deck to be shuffled (used)*/
      do t=1  until eq();  call magic;  end      /*shuffle until  before  equals  after.*/

    say 'deck size:'    right(y,w)","       right(t,w)      'perfect shuffles.'
    end     /*j*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
eq:           do ?=1  for y;    if @.?\==?  then return 0;    end;            return 1
/*──────────────────────────────────────────────────────────────────────────────────────*/
magic: z=1;                     h=y%2                        /*H  is (half─way) pointer.*/
              do L=3  by 2  for h-1; z=z+1; !.L=@.z; end     /*assign left half of deck.*/
              do R=2  by 2  for h-1; h=h+1; !.R=@.h; end     /*   "   right  "   "   "  */
              do a=2        for y-2;        @.a=!.a; end     /*re─assign──►original deck*/
       return

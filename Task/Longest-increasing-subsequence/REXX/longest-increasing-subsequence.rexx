/*REXX program finds & displays the  longest increasing subsequence  from a list of #'s.*/
$.=;  $.1= 3 2 6 4 5 1                           /*define the 1st list to be examined.  */
      $.2= 0 8 4 12 2 10 6 14 1 9 5 13 3 11 7 15 /*   "    "  2nd   "   "  "     "      */

        do j=1   while  $.j\=='';     say        /* [↓]  process all of the list for LIS*/
        say ' input: '  $.j                      /*display the (original) input list.   */
        call LIS        $.j                      /*invoke the  LIS  function.           */
        say 'output: '  result                   /*display the  output (result from LIS)*/
        end   /*j*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
LIS: procedure; parse arg x;   n= words(x);   if n==0  then return ''
     p.=;                            m.= p.
           do #=1  to n;  _= # - 1;  @._= word(x, #)    /*build an array (@) from input.*/
           end   /*#*/
     L= 0
           do j=0  to n-1;  lo= 1
           HI= L
                     do  while LO<=HI;    middle= (LO+HI) % 2
                          _= m.middle            /*create a temporary value for @ index.*/
                     if @._<@.j  then LO= middle + 1
                                 else HI= middle - 1
                     end   /*while*/
           newLO= LO
                  _= newLO - 1                   /*create a temporary value for M index.*/
           p.j= m._
           m.newLO= j
           if newLO>L  then L= newLO
           end   /*i*/
     k= m.L;                $=                   /* [↓]  build a list for the result.   */
                     do L;  $= @.k $;  k= p.k    /*perform this  DO  loop   L   times.  */
                     end   /*i*/
     return strip($)                             /*the result has an extra leading blank*/

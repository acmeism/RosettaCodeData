/*REXX program computes and displays palindromic gapful numbers, it also can show those */
/*─────────────────────── palindromic gapful numbers listed by their last decimal digit.*/
numeric digits 20                                /*ensure enough decimal digits gapfuls.*/
parse arg palGaps                                /*obtain optional arguments from the CL*/
if palGaps=''  then palGaps= 20 100@@15 1000@@10 /*Not specified?  Then use the defaults*/

        do until palGaps='';      parse var palGaps  stuff palGaps;      call palGap stuff
        end   /*until*/
exit 0                                           /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
palGap: procedure; parse arg n '@' sp "@" z;    #= 0;    if sp==''  then sp= 100
        @ending= '  (ending in a specific digit) ';      if  z==''  then  z=   n
        @which= ' last ';                                if  z==n   then @which= " first "
        @palGap#Start= ' palindromic gapful numbers starting at: '
        say center(@which   z    ' of '     n   @palGap#Start   sp" "   @ending, 140, "═")
        #.= 0                                    /*array of result counts for each digit*/
        newSP= max(110, sp%11*11)                /*calculate the new starting point.    */
        tot= n * 9                               /*total # of results that are wanted.  */
        $.=;                           sum= 0    /*blank lists;  digit results (so far).*/
              do j=newSP  by 11  until sum==tot  /*loop 'til all digit counters filled. */
              if reverse(j)  \==j  then iterate  /*Not a palindrome?       Then skip it.*/
              parse var   j   a  2  ''  -1  b    /*obtain the first and last dec. digit.*/
              if #.b          ==n  then iterate  /*Digit quota filled?     Then skip it.*/
              if j // (a||b) \==0  then iterate  /*Not divisible by A||B?    "    "   " */
              sum= sum + 1;        #.b= #.b + 1  /*bump the sum counter & digit counter.*/
              $.b= $.b  j                        /*append   J   to the correct list.    */
              end   /*j*/
                                                 /* [↓]  just show the last  Z  numbers.*/
              do k=1  for 9;   say  k':'   strip( subword($.k, 1 + n - z) )
              end   /*k*/;     say
        return

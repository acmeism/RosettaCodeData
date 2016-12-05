/*REXX program using Knuth's algorithm S (a random sampling  N  of  M  items).*/
parse arg trials size .                /*obtain optional arguments from the CL*/
if trials==''  then trials=100000      /*Not specified?  Then use the default.*/
if   size==''  then   size=     3      /* "      "         "   "   "     "    */
#.=0                                   /*initialize frequency counter array.  */
      do trials                        /*OK,  now let's light this candle.    */
      call s_of_n_creator    size      /*create an initial list of  N  items. */

         do gener=0  for 10
         call s_of_n gener             /*call s_of_n with a single decimal dig*/
         end       /*gener*/

             do count=1  for size      /*let's examine what  SofN  generated. */
             _=!.count                 /*get a decimal digit from the   Nth   */
             #._=#._+1                 /*  ··· item,  and count it, of course.*/
             end   /*count*/
      end          /*trials*/
                                                      @='trials, and with size='
say "Using Knuth's algorithm  S  for"  commas(trials) @ || commas(size)":"
say
      do dig=0  to 9                   /* [↓]  display the frequency of a dig.*/
      say left('',20)   "frequency of the"    dig    'digit is:'   commas(#.dig)
      end   /*dig*/
exit                                   /*stick a fork in it,  we're all done. */
/*────────────────────────────────────────────────────────────────────────────*/
commas: procedure;  parse arg _;   n=_'.9';    #=123456789;    b=verify(n,#,"M")
        e=verify(n, #'0', , verify(n, #"0.", 'M')) - 4
           do j=e  to b  by -3;   _=insert(',',_,j);    end  /*j*/;     return _
/*────────────────────────────────────────────────────────────────────────────*/
s_of_n: parse arg item;  items=items+1 /*get  "item",  bump the items counter.*/
        c=random(1, items)             /* [↓]  should replace a previous item?*/
        if c>size  then return         /*probability isn't good,  so skip it. */
        _=random(1, size);  !._=item   /*now, figure out which previous ···   */
        return                         /*      ··· item to replace with  ITEM.*/
/*────────────────────────────────────────────────────────────────────────────*/
s_of_n_creator: parse arg item 1 items /*generate    ITEM    number of items. */
                     do k=1  for item  /*traipse through the first  N  items. */
                     !.k=random(0, 9)  /*set the  Kth  item with random digit.*/
                     end   /*k*/
        return                         /*the piddly stuff is done  (for now). */

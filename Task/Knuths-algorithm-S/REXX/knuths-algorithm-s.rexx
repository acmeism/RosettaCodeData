/*REXX program using Knuth's algorithm S  (a random sampling  N of M  items). */
parse arg trials size .                /*obtain optional arguments from the CL*/
if trials==''  then trials=100000      /*Not specified?  Then use the default.*/
if   size==''  then size=3             /* "      "         "   "   "     "    */
#.=0                                   /*initialize an array of freq counters.*/
      do trials                        /*OK, now let's light this candle.     */
      call SofN_creator  size          /*create initial list of   N   items.  */

         do gener=0  for 10            /*and then call  SofN  for each digit. */
         call SofN   gener             /*call  SofN  with a single decimal dig*/
         end       /*gener*/

             do count=1  for size      /*let's examine what  SofN  generated. */
             _=!.count                 /*get a digit from the  Nth  item, and */
             #._=#._+1                 /*          ···  count it, of course.  */
             end   /*count*/
      end          /*trials*/

say "Using Knuth's algorithm  S  for"   commas(trials),
                                  'trials, and with size='commas(size)":";   say
      do dig=0  to 9                   /* [↓]  display the frequency of a dig.*/
      say left('',15)   "frequency of the"    dig    'digit is:'   commas(#.dig)
      end   /*dig*/
exit                                   /*stick a fork in it,  we're all done. */
/*────────────────────────────────────────────────────────────────────────────*/
SofN_creator: parse arg item 1 items   /*generate  ITEM  number of items.     */
                 do k=1  for item      /*traipse through the firs  N  items.  */
                 !.k=random(0, 9)      /*set the  Kth  item with random digit.*/
                 end   /*k*/
return                                 /*the piddly stuff is done for now.    */
/*────────────────────────────────────────────────────────────────────────────*/
SofN:  parse arg item;  items=items+1  /*get  "item",  bump the items counter.*/
c=random(1, items)                     /*should we replace a previous item?   */
if c>size  then return                 /*probability isn't good, so skip it.  */
_=random(1, size)                      /*now, figure out which previous ···   */
!._=item                               /*     ··· item to replace with  ITEM. */
return
/*────────────────────────────────────────────────────────────────────────────*/
commas: procedure;  parse arg _;   n=_'.9';    #=123456789;    b=verify(n,#,"M")
        e=verify(n,#'0',,verify(n,#"0.",'M'))-4
           do j=e  to b  by -3;   _=insert(',',_,j);    end  /*j*/;     return _

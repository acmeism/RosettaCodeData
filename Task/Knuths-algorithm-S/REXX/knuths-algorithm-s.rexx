/*REXX program using Knuth's algorithm S (random sampling n of M items).*/
parse arg trials size .                /*obtain the arguments from C.L. */
if trials==''  then trials=100000      /*use default if not specified.  */
if   size==''  then size=3             /* "     "     "  "      "       */
#.=0                                   /*a couple handfuls of counters. */
      do trials                        /*OK, let's light this candle.   */
      call s_of_n_creator size         /*create initial list of n items.*/

         do gener=0  for 10            /*and then call SofN for each dig*/
         call s_of_n gener             /*call  s_of_n  with a single dig*/
         end       /*gener*/

             do count=1  for size      /*let's see what  s_of_n  wroth. */
             _=!.count                 /*get a digit from the Nth item, */
             #._=#._+1                 /* ... and count it, of course.  */
             end   /*count*/
      end          /*trials*/

say "Using Knuth's algorihm  S  for" comma(trials) 'trials, and with size='comma(size)":"
say
      do dig=0 to 9                    /*show & tell time for frequency.*/
      say copies(' ',15) "frequency of the" dig 'digit is:' comma(#.dig)
      end   /*dig*/
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────S_OF_N_CREATOR subroutine───────────*/
s_of_n_creator: parse arg item 1 items /*generate  ITEM  number of items*/
             do k=1  for item          /*traipse through the 1st N items*/
             !.k=random(0,9)           /*set the Kth item with rand dig.*/
             end   /*k*/
return                                 /*out piddly work is done for now*/
/*──────────────────────────────────S_OF_N subroutine───────────────────*/
s_of_n: parse arg item; items=items+1  /*get "item", bump items counter.*/
c=random(1,items)                      /*should we replace a prev item? */
if c>size  then return                 /*probability isn't good, skip it*/
_=random(1,size)                       /*now, figure out which previous */
!._=item                               /* ... item to replace with ITEM.*/
return                                 /*and back to the caller we go.  */
/*──────────────────────────────────COMMA subroutine────────────────────*/
comma: procedure; parse arg _,c,p,t;arg ,cu;c=word(c ",",1)
       if cu=='BLANK' then c=' '; o=word(p 3,1); p=abs(o); t=word(t 999999999,1)
       if \datatype(p,'W') | \datatype(t,'W') | p==0 | arg()>4 then return _
       n=_'.9'; #=123456789; k=0; if o<0 then do; b=verify(_,' '); if b==0 then return _
       e=length(_)-verify(reverse(_),' ')+1; end; else do; b=verify(n,#,"M")
       e=verify(n,#'0',,verify(n,#"0.",'M'))-p-1; end
       do j=e to b by -p while k<t; _=insert(c,_,j); k=k+1; end; return _

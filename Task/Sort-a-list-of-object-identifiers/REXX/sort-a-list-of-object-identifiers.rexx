/*REXX program performs a  sort  of  OID  (Object IDentifiers ◄── used in Network data).*/
call gen                                         /*generate an array (@.) from the OIDs.*/
call show   'before sort ───► '                  /*display the  @  array before sorting.*/
                             say copies('░', 79) /*   "   fence, separate before & after*/
call adj    1                                    /*expand  the  $  list of OID numbers. */
call bSort  #                                    /*sort     "   "    "   "  "     "     */
call adj    0                                    /*shrink   "   "    "   "  "     "     */
call show   ' after sort ───► '                  /*display the  @  array after sorting. */
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
bSort: procedure expose @.; parse arg n;   m=n-1 /*N: is the number of @ array elements.*/
          do m=m  for m  by -1  until ok;  ok= 1 /*keep sorting the @ array until done. */
             do j=1  for m;     _= j + 1         /*calculate the next (index) in @ array*/
             if @.j>@._  then parse value    @.j  @._  0      with      @._  @.j  ok
             end   /*j*/                         /* [↑]  swap two out─of─order elements.*/
          end      /*m*/                         /* [↑]  use a simple  bubble  sort.    */
       return
/*──────────────────────────────────────────────────────────────────────────────────────*/
gen:   $=    1.3.6.1.4.1.11.2.17.19.3.4.0.10 ,   /* ◄──┐                                */
             1.3.6.1.4.1.11.2.17.5.2.0.79    ,   /* ◄──┤                                */
             1.3.6.1.4.1.11.2.17.19.3.4.0.4  ,   /* ◄──┼─◄─ six OID numbers (as a list).*/
             1.3.6.1.4.1.11150.3.4.0.1       ,   /* ◄──┤                                */
             1.3.6.1.4.1.11.2.17.19.3.4.0.1  ,   /* ◄──┤                                */
             1.3.6.1.4.1.11150.3.4.0             /* ◄──┘                                */
       w= 0                                                      /*W: max length of #'s.*/
       #= words($);     do i=1  for #;    @.i= word($, i);    w= max(w, length(@.i) )
                        end   /*i*/                              /*W: max length of #'s.*/
       return
/*──────────────────────────────────────────────────────────────────────────────────────*/
adj:   arg LZ;  do j=1  for #;       x= translate(@.j, , .);  y= /*construct X version. */
                   do k=1  for words(x);           _= word(x, k) /*get a number in  X.  */
                   if LZ  then y= y right(_, w, 0)               /*(prepend) leading 0's*/
                          else y= y    (_   +   0)               /* (elide)     "     " */
                   end   /*k*/
                @.j = translate( space(y), ., ' ')               /*reconstitute number. */
                end      /*j*/                                   /*LZ:  Leading Zero(s).*/
       return                                                    /*──   ─       ─       */
/*──────────────────────────────────────────────────────────────────────────────────────*/
show:  do a=1 for #; say right("OID number",20) right(a,length(#)) arg(1) @.a; end; return

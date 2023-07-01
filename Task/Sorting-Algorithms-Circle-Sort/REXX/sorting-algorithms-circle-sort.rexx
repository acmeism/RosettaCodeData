/*REXX program uses a  circle sort algorithm  to sort an array (or list) of numbers.    */
parse arg x                                      /*obtain optional arguments from the CL*/
if x='' | x=","  then x= 6 7 8 9 2 5 3 4 1       /*Not specified?  Then use the default.*/
call make_array  'before sort:'                  /*display the list and make an array.  */
call circleSort       #                          /*invoke the circle sort subroutine.   */
call make_list   ' after sort:'                  /*make a list and display it to console*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
circleSort:      do while  .circleSrt(1, arg(1), 0)\==0;     end;                   return
make_array: #= words(x);    do i=1 for #;  @.i= word(x, i);  end;  say arg(1)  x;   return
make_list:  y= @.1;         do j=2 for #-1;  y= y  @.j;      end;  say arg(1)  y;   return
.swap:      parse arg a,b;  parse  value  @.a @.b  with  @.b @.a;  swaps= swaps+1;  return
/*──────────────────────────────────────────────────────────────────────────────────────*/
.circleSrt: procedure expose @.;  parse arg LO,HI,swaps    /*obtain  LO & HI  arguments.*/
            if LO==HI  then return swaps                   /*1 element?  Done with sort.*/
            high= HI;      low= LO;     mid= (HI-LO) % 2   /*assign some indices.       */
                                                           /* [↓]  sort a section of #'s*/
                       do  while LO<HI                     /*sort within a section.     */
                       if @.LO>@.HI  then call .swap LO,HI /*are numbers out of order ? */
                       LO= LO + 1;        HI= HI - 1       /*add to LO;  shrink the HI. */
                       end   /*while*/                     /*just process one section.  */
            _= HI + 1                                      /*point to  HI  plus one.    */
            if LO==HI  &  @.LO>@._  then call .swap LO, _  /*numbers still out of order?*/
            swaps= .circleSrt(low,        low+mid,  swaps) /*sort the   lower  section. */
            swaps= .circleSrt(low+mid+1,  high,     swaps) /*  "   "   higher     "     */
            return swaps                                   /*the section sorting is done*/

/*REXX program determines if a (calendar) year is a SHORT or LONG year (52 or 53 weeks).*/
parse arg LO HI .                                             /*obtain optional args.   */
if LO=='' | LO=="," | LO=='*'  then LO= left( date('S'), 4)   /*Not given?  Use default.*/
if HI=='' | HI==","            then HI= LO                    /* "    "      "     "    */
if                    HI=='*'  then HI= left( date('S'), 4)   /*an asterisk ≡ current yr*/

       do j=LO  to  HI                           /*process single yr  or range of years.*/
       say '     year '  j  " is a "   right( word('short long', weeks(j)-51),5)   " year"
       end   /*j*/
exit 0                                           /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
pWeek: parse arg #;  return  (#    +    # % 4    -    # % 100    +    # % 400)     //   7
weeks: parse arg y;  if pWeek(y)==4  |  pWeek(y-1)==3  then return 53;           return 52

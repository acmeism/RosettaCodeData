/*REXX program introduces   IF2,   a type of four-way compound  IF:     */

  do n=10  to 20                       /*put DO loop through it's paces.*/
                                       /* [↓]  divisible by 2 and/or 3? */
  if2( n//2==0, n//3==0)               /*use the four-way  IF statement.*/
      select                           /*now, test the 4 possible cases.*/
      when if.11  then say n  "is divisible by both two and three."
      when if.10  then say n  "is divisible by two, but not by three."
      when if.01  then say n  "is divisible by three, but not by two."
      when if.00  then say n  "is neither divisible by two, nor by three."
      otherwise nop                    /* ◄─┬─this statement is optional*/
      end   /*select*/                 /*   ├─ and only exists in case  */
  end       /*n*/                      /*   ├─ one or more WHENs (above)*/
                                       /*   └─ are omitted.             */
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────IF2 routine─────────────────────────*/
if2: parse arg if.10, if.01            /*assign the cases  10  and  01  */
               if.11= if.10 & if.01    /*   "    "  case   11           */
               if.00= \(if.10 | if.01) /*   "    "    "    00           */
return ''                              /*return to the invoker of  IF2. */

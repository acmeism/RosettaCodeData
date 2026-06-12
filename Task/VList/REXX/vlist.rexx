/*REXX program demonstrates  VList  operations:   add,  update,  delete, insert,  show. */
                                                 /*could use instead:     q  =  1 2 3 4 */
call  q  0, 1 2 3 4                              /*populate the list with values 1 ── ►4*/
say q(4)                                         /*show the indexed access to an item.  */

call q  2, 'Fred'                                /*update  (or add)  the second item.   */
say q(2) q(4)                                    /*show second and fourth items in list.*/
                                                 /*zeroth item is inserted in the front.*/
call q  0, 'Mike'                                /*insert item in front of the list.    */
say q(1) q(2) q(4)                               /*show first, second, and fourth items.*/
                                                 /*any  negative number  is deleted.    */
call q  -1                                       /*delete the first item in the list.   */
say q(1) q(2) q(4)                               /*show the  1st,  2nd,  and  4th items.*/
                                                 /*Fractional number inserts an item.   */
call q  3.5, '3½'                                /*insert the item after the third item.*/
say q ,                                          /*show all the  VList  items.          */
                                                 /*Put on a dog and pony show.          */
say 'number of items in Vlist:' q()              /*show and tell time for the  Vlist.   */
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
q: parse arg n 1 na 1 ni,!;   w=words(q);   $=             /*obtain arguments;  # items.*/
   if symbol('Q')=='LIT' then q=                           /*var Q may not be defined.  */
   if arg()==0        then return words(q)                 /*return the VList item count*/
   if arg(1, 'O')     then return q                        /*return the whole shebang.  */
   if arg()==1 & n>0  then return word(q,n)                /*1 positive arg?  Return it.*/
   if n==0            then do;  q=! q;  return q;  end     /*insert in front of the list*/
   if n> w            then do;  q=q !;  return q;  end     /*add it to  end.  "  "    " */
   na=abs(n)                                               /*we might need use of  ABS. */
   if \datatype(ni, 'W') & ni>0  then ni=trunc(na)         /*Is this an insert>?  TRUNC.*/
                                 else ni=0                 /*... No?  Then a plain Jane.*/
          do j=1 for w                                     /* [↓]  rebuild the  Vlist.  */
          if j==na  then do; if na==n then $=$ !;  end     /*replace the item in list.  */
                    else $=$ word(q, j)                    /*an easy-peasy (re-)build.  */
          if j==ni  then $=$ !                             /*handle the  "insert".      */
          end   /*j*/
   q=space($);           return q                          /*elide superfluous blanks.  */

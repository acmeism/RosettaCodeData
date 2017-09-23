/*REXX program orders a  disjoint list  of   M   items  with a list of   N   items.     */
used = '0'x                                      /*indicates that a word has been parsed*/
@.   =                                           /*placeholder indicates  end─of─array, */
@.1  =   " the cat sat on the mat        |      mat cat  "                  /*a string. */
@.2  =   " the cat sat on the mat        |      cat mat  "                  /*"    "    */
@.3  =   " A B C A B C A B C             |      C A C A  "                  /*"    "    */
@.4  =   " A B C A B D A B E             |      E A D A  "                  /*"    "    */
@.5  =   " A B                           |      B        "                  /*"    "    */
@.6  =   " A B                           |      B A      "                  /*"    "    */
@.7  =   " A B B A                       |      B A      "                  /*"    "    */
@.8  =   "                               |               "                  /*"    "    */
@.9  =   " A                             |      A        "                  /*"    "    */
@.10 =   " A B                           |               "                  /*"    "    */
@.11 =   " A B B A                       |      A B      "                  /*"    "    */
@.12 =   " A B A B                       |      A B      "                  /*"    "    */
@.13 =   " A B A B                       |      B A B A  "                  /*"    "    */
@.14 =   " A B C C B A                   |      A C A C  "                  /*"    "    */
@.15 =   " A B C C B A                   |      C A C A  "                  /*"    "    */
      /*  ════════════M═══════════             ════N════      */

  do j=1  while  @.j\==''                        /* [↓]  process each input string (@.).*/
  parse var  @.j  m  '|'  n                      /*parse input string into  M  and  N.  */
  #=words(m)                                     /*#:   number of words in the  M  list.*/
                do i=#  for #  by -1             /*process list items in reverse order. */
                _=word(m, i);   !.i=_;    $._=i  /*construct the   !.   and  $.  arrays.*/
                end   /*i*/
  r.=                                            /*nullify the replacement string  [R.] */
       do k=1  by 2  for  words(n) % 2           /* [↓]  process the  N  array.         */
       _=word(n, k);     v=word(n, k+1)          /*get an order word and the replacement*/
       p1=wordpos(_, m); p2=wordpos(v, m)        /*positions of   "   "   "       "     */
       if p1==0 | p2==0  then iterate            /*if either not found, then skip them. */
       if $._>>$.v  then do;  r.p2=!.p1;  r.p1=!.p2;  end            /*switch the words.*/
                    else do;  r.p1=!.p1;  r.p2=!.p2;  end            /*don't switch.    */
       !.p1=used; !.p2=used                                          /*mark 'em as used.*/
       m=
                        do i=1  for #;  m=m !.i;  _=word(m, i);  !.i=_;  $._=i;  end /*i*/
       end   /*k*/                               /* [↑]  rebuild the  !. and  $. arrays.*/
  mp=                                            /*the  MP  (aka M')  string  (so far). */
       do q=1  for #;   if !.q==used  then mp=mp  r.q                /*use the original.*/
                                      else mp=mp  !.q                /*use substitute.  */
       end   /*q*/                               /* [↑]  re─build the (output) string.  */

  say @.j   ' ────► '   space(mp)                /*display new re─ordered text ──► term.*/
  end        /*j*/                               /* [↑]  end of processing for  N  words*/
                                                 /*stick a fork in it,  we're all done. */

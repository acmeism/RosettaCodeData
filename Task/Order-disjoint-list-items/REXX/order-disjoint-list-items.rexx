/*REXX program orders a disjoint list of M items with a list of N items.*/
used = '0'x                            /*indicates word has been parsed.*/
@.   =                                 /*placeholder indicates e─o─array*/
@.1  =   " the cat sat on the mat      |      mat cat "        /*string.*/
@.2  =   " the cat sat on the mat      |      cat mat "        /*string.*/
@.3  =   " A B C A B C A B C           |      C A C A "        /*string.*/
@.4  =   " A B C A B D A B E           |      E A D A "        /*string.*/
@.5  =   " A B                         |      B       "        /*string.*/
@.6  =   " A B                         |      B A     "        /*string.*/
@.7  =   " A B B A                     |      B A     "        /*string.*/
@.8  =   "                             |              "        /*string.*/
@.9  =   " A                           |      A       "        /*string.*/
@.10 =   " A B                         |              "        /*string.*/
@.11 =   " A B B A                     |      A B     "        /*string.*/
@.12 =   " A B A B                     |      A B     "        /*string.*/
@.13 =   " A B A B                     |      B A B A "        /*string.*/
@.14 =   " A B C C B A                 |      A C A C "        /*string.*/
@.15 =   " A B C C B A                 |      C A C A "        /*string.*/
                                       /* [↓]  process each input string*/
  do j=1  while  @.j\=='';   r.=       /*nullify the replacement string.*/
  parse var @.j m '|' n                /*parse input string into  M & N.*/
  mw=words(m);   do i=mw for mw by -1;   x=word(m,i);  !.i=x;  $.x=i;  end
                                       /* [↑]  build  ! and $  arrays.  */
    do k=1  for  words(n)%2  by 2      /* [↓]  process the  N  array.   */
    _=word(n,k);   v=word(n,k+1)       /*get an order word & replacement*/
    p1=wordpos(_,m);  p2=wordpos(v,m)  /*positions of word & replacement*/
    if p1==0 | p2==0  then iterate     /*if either not found, skip 'em. */
    if $._>>$.v  then do;  r.p2=!.p1; r.p1=!.p2;  end    /*switch words.*/
                 else do;  r.p1=!.p1; r.p2=!.p2;  end    /*don't switch.*/
    !.p1=used; !.p2=used;  m=                            /*mark as used.*/
              do i=1  for mw;  m=m !.i; x=word(m,i);  !.i=x;  $.x=i;  end
    end   /*k*/                        /* [↑]  rebuild the ! & $ arrays.*/
  mp=                                  /*the  MP  (M')  string (so far).*/
       do q=1  for mw;   if !.q==used  then mp=mp r.q   /*use original. */
                                       else mp=mp !.q   /*use substitute*/
       end   /*q*/                     /* [↑]  re-build the (output) str*/
                                       /*═══════════════════════════════*/
  say @.j  '───►'  space(mp)           /*display the new text reordered.*/
  end      /*j*/                       /* [↑]  end of processing N words*/
                                       /*stick a fork in it, we're done.*/

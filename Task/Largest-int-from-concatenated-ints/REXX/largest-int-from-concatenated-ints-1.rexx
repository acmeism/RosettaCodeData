/*REXX program constructs the largest integer  from an integer list using concatenation.*/
@.=.;     @.1 = '1  34  3  98  9  76  45  4'     /*the  1st  integer list to be used.   */
          @.2 = '54  546  548  60'               /* "   2nd     "      "   "  "   "     */
          @.3 = ' 4   45   54   5'               /* "   3rd     "      "   "  "   "     */
w=0                                              /* [↓]   process all the integer lists.*/
    do j=1  while @.j\==.;         z=space(@.j)  /*keep truckin' until lists exhausted. */
    w=max(w, length(z) );          $=            /*obtain maximum width to align output.*/
        do  while z\='';  idx=1;   big=norm(1)   /*keep examining the list  until  done.*/
          do k=2  to  words(z);    #=norm(k)     /*obtain an a number from the list.    */
          L=max(length(big), length(#) )         /*get the maximum length of the integer*/
          if left(#, L, left(#, 1) )   <<=   left(big, L, left(big, 1) )    then iterate
          big=#;                  idx=k          /*we found a new biggie (and the index)*/
          end   /*k*/                            /* [↑]  find max concatenated integer. */
        z=delword(z, idx, 1)                     /*delete this maximum integer from list*/
        $=$ || big                               /*append   "     "       "    ───►  $. */
        end     /*while z*/                      /* [↑]  process all integers in a list.*/
    say 'largest concatenatated integer from '  left( space(@.j), w)    " is ─────► "    $
    end         /*j*/                            /* [↑]  process each list of integers. */
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
norm: arg i;  #=word(z, i);   er=' ***error*** ';  if left(#, 1)=="-"  then #=substr(#, 2)
      if \datatype(#,'W')  then do; say er 'number'  #  "isn't an integer."; exit 13;  end
      return # / 1                               /*it's an integer,  then normalize it. */

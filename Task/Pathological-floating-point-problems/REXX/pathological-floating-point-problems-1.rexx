/*REXX pgm (pathological FP problem):  a sequence that might converge to a wrong limit. */
parse arg digs show .                            /*obtain optional arguments from the CL*/
if digs=='' | digs==","  then digs= 150          /*Not specified?  Then use the default.*/
if show=='' | show==","  then show=  20          /* "      "         "   "   "     "    */
numeric digits digs                              /*have REXX use "digs" decimal digits. */
#= 2 4 5 6 7 8 9 20 30 50 100                    /*the indices to display value of  V.n */
fin= word(#, words(#) )                          /*find the last (largest) index number.*/
w= length(fin)                                   /*  "   "  length (in dec digs) of FIN.*/
v.1= 2                                           /*the value of the first   V  element. */
v.2=-4                                           /* "    "    "  "  second  "     "     */
      do n=3  to fin;   nm1= n-1;     nm2= n-2   /*compute some values of the V elements*/
      v.n= 111 - 1130/v.nm1 + 3000/(v.nm1*v.nm2) /*   "      a  value  of  a  " element.*/
                                                 /*display digs past the dec. point───┐ */
      if wordpos(n, #)\==0  then say   'v.'left(n, w)       "="        format(v.n, , show)
      end   /*n*/                                /*stick a fork in it,  we're all done. */

/*REXX pgm computes a Recamán sequence up to N; the 1st dup; # terms for a range of #'s.*/
parse arg N h .                                  /*obtain optional arguments from the CL*/
if N=='' | N==","  then N=   15                  /*Not specified?  Then use the default.*/
if h=='' | h==","  then h= 1000                  /* "      "         "   "   "     "    */
      say "Recamán's sequence for the first "        N         " numbers: "    recaman(N)
say;  say "The first duplicate number in the Recamán's sequence is: "          recaman(0)
say;  say "The number of terms to complete the range  0───►"h    ' is: '       recaman(-h)
exit 0                                           /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
recaman: procedure; parse arg y,,d.; $=0;  !.=0;   _=0;   !.0=1  /*init. array and vars.*/
                    r= y<0;          Reca= 0;    hi= abs(y)      /*for the 2nd invoke.  */
                    o= y==0;         if y<1  then y= 1e8         /* "   "  3rd    "     */
           do #=1  for y-1;          z= _ - #                    /*next # might be < 0. */
           if z<0  then              z= _ + #                    /*this is faster than: */
                   else if !.z  then z= _ + #                    /*if !.z | z<0 then ···*/
           !.z= 1;                      _= z                     /*mark it;  add to seq.*/
           if r  then do;  if z>hi      then iterate             /*ignore #'s too large.*/
                           if d.z==''   then Reca= Reca + 1      /*Unique? Bump counter.*/
                           d.z= .                                /*mark # as a new low. */
                           if Reca>=hi  then return #            /*list is complete ≥ HI*/
                           iterate
                      end                                        /* [↑]  a range of #s. */
           if o  then do;  if d.z==.  then return z;  d.z=.;  iterate  /*check if dup #.*/
                      end
           $= $ z                                                /*add number to $ list?*/
           end   /*#*/;                    return $              /*return the  $  list. */

/*REXX program shows exponentition with an  infix operator  (implied and/or specified).*/
_= '─';   ! = '║';   mJunct= '─╫─';   bJunct= '─╨─'       /*define some special glyphs. */

say @('  x  ', 5)  @("  p  ", 5)        !
say @('value', 5)  @("value", 5) copies(!        @('expression',10)  @("result",6)" ",  4)
say @(''  , 5, _)  @("",   5, _)copies(mJunct || @('',       10, _)  @("",   6, _)   ,  4)

   do    x=-5  to 5  by 10                       /*assign   -5    and    5    to    X.  */
      do p= 2  to 3                              /*assign    2    and    3    to    P.  */

                           a =  -x**p ;   b =  -(x)**p ;   c =  (-x)**p ;   d =  -(x**p)
                           ae= '-x**p';   be= "-(x)**p";   ce= '(-x)**p';   de= "-(x**p)"
      say @(x,5)  @(p,5) ! @(ae, 10)    right(a, 5)" " ,
                         ! @(be, 10)    right(b, 5)" " ,
                         ! @(ce, 10)    right(c, 5)" " ,
                         ! @(de, 10)    right(d, 5)
      end   /*p*/
   end      /*x*/

say @(''  , 5, _)  @('',   5, _)copies(bJunct || @('',       10, _)  @('',   6, _)   ,  4)
exit 0                                           /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
@:    parse arg txt, w, fill;  if fill==''  then fill= ' ';   return center( txt, w, fill)

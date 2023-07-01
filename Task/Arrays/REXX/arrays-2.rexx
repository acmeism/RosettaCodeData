/*REXX program  demonstrates  array usage  with mimicry.                */
a. = 'not found'                       /*value for all a.xxx  (so far). */
                  do j=1  to 100       /*start at 1, define 100 elements*/
                  a.j = -j * 100       /*define element as  -J hundred. */
                  end   /*j*/          /*the above defines 100 elements.*/

say 'element 50 is:'    a(50)
say 'element 3000 is:'  a(3000)
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────A subroutine────────────────────────*/
a:   _a_ = arg(1);          return  a._a_

/*REXX program demonstrates array usage with assigned default.*/
a.=00                        /*value for all    a.xxx     (so far).  */

  do j=1 to 100              /*start at 1, define 100 array elements.*/
  a.j=-j*100                 /*define element as negative J thousand.*/
  end                        /*the above defines 100 elements.       */

say 'element 50 is:' a.50
say 'element 3000 is:' a.3000

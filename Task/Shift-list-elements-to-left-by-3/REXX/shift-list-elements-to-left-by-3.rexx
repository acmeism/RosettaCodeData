/*REXX program  shifts  (using a rotate)  elements in a list  left  by some number  N.  */
parse arg n $ .                                  /*obtain optional arguments from the CL*/
if n=='' | n==","  then n= 3                     /*Not specified?  Then use the default.*/
if $=='' | $==","  then $= '[1,2,3,4,5,6,7,8,9]' /* "      "         "   "   "     "    */

$$= space( translate($, , '],[') )               /*convert literal list to bare list.   */
$$= '['translate( subword($$, N+1)  subword($$, 1, n), ',', " ")']'   /*rotate the list.*/

say 'shifting elements in the list by '  n       /*display action used on the input list*/
say ' input list='   $                           /*   "    the  input list ───► terminal*/
say 'output list='  $$                           /*   "    the output   "    "      "   */

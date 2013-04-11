/*REXX program to find the  roots  of a  specific  function.            */
parse arg bot top inc .                /*allow user to specify options. */
if bot=='' | bot==','  then bot=-3     /*Not specified? Then use default*/
if top=='' | top==','  then top=+3     /* "       "       "   "     "   */
if inc=='' | inc==','  then inc=.0001  /* "       "       "   "     "   */
z=f(bot);  !=sign(z)

      do j=bot  to top  by  inc        /*traipse through all the values.*/
      z=f(j);   $=sign(z)              /*compute new value and the sign.*/
      if z=0 then                               say 'found a root at'  j/1
             else if !\==$  then if !\==0  then say 'passed a root at' j/1
      !=$                              /*use the new sign.              */
      end   /*j*/
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────F function──────────────────────────*/
f: procedure;   parse arg x;   return  x**3  -  3 * x**2   +   2 * x

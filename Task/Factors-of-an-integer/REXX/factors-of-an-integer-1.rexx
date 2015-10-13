/*REXX program displays divisors of any  [negative/zero/positive]  integer(s).*/
parse arg bot top inc .                                       /*optional args.*/
top=word(top bot 20,1); bot=word(bot 1,1); inc=word(inc 1,1)  /*range options.*/
w=length(high)+1;       numeric digits max(9,w);      $='∞'   /*digits for // */
@.=left('',7); @.1='{unity}'; @.2='[prime]'; @.$='  {'$"}  "  /*some literals.*/
say center('n',1+w)   '#divisors'   center('divisors',60)     /*show a header.*/
say copies('═',1+w)   '═════════'   copies('═'       ,60)     /*  "  "  sep.  */

     do n=bot  to top  by inc;   divs=divisors(n);    #=words(divs)
     if divs==$  then do;  #=$;  divs='  (infinite)'; end    /*handle infinity*/
     p=@.#;           if n<0  then p=@..                     /*handle negative*/
     say center(n,w+1)    center('['#"]",9)     "──► "       p      ' '     divs
     end   /*n*/                       /* [↑]   process a range of integers.  */
exit                                   /*stick a fork in it,  we're all done. */
/*────────────────────────────────────────────────────────────────────────────*/
divisors: procedure;  parse arg x;        x=abs(x);    if x==1  then return  1
odd=x//2;             b=x;                             if x==0  then return '∞'
a=1                                    /* [↓]  process only EVEN│ODD integers.*/
   do j=2+odd  by 1+odd  while j*j<x   /*divide by all integers up to  √x.    */
   if x//j==0  then do; a=a j; b=x%j b; end    /*÷?  Add factors to α&ß lists.*/
   end   /*j*/                         /* [↑]  %   is REXX's integer division.*/
                                       /* [↓]  adjust for a square.       ___ */
if j*j==x  then  return  a j b         /*Was X a square?  If so, insert  √ x  */
                 return  a   b         /*return the divisors of both lists.   */

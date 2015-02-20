/*REXX program lists  Pythagorean triples  up to a specified number.    */
parse arg n .                          /*get the optional argument.     */
if n==''  then n=100                   /*Not specified?  Then assume 100*/
$=                                     /*assign a null to triples list. */
      do     a=1   for n-2;  aa=a*a    /*Note:  A*A is faster than A**2,*/
        do   b=a+1  to n-1;  aabb=aa+b*b        /*  ··· but not by much.*/
          do c=b+1  to n
          if aabb==c*c  then $=$  '('a","   ||   b','c")"
          end   /*c*/
        end     /*b*/
      end       /*a*/

if 'f5'x==5  then do;  sup2='b2'x;  le='8c'x;  end   /*EBCDIC?*/
             else do;  sup2='fd'x;  le='f3'x;  end   /* ASCII?*/
say  'Pythagorean triples   (a'sup2 "+ b"sup2 '= c'sup2",   c "le n'):'
w=words($)                             /*number of members in the list. */
say;          do j=1  for w            /*display the members of the list*/
              say word($,j)            /*display  a  member  of the list*/
              end   /*j*/              /* [↑]   list members vertically.*/

say;   say  w  'members listed.'       /*stick a fork in it, we're done.*/

/*REXX program lists (horizontally) Pythagorean triples up to a specified num.*/
parse arg n .                          /*get the optional argument from the CL*/
if n==''  then n=100                   /*Not specified?  Then use the default.*/
$=                                     /*assign a  null  to the triples list. */
      do     a=1   for n-2;  aa=a*a    /*Note:  A*A is faster than A**2, but  */
        do   b=a+1  to n-1;  aabb=aa+b*b                   /* ··· not by much.*/
          do c=b+1  to n
          if aabb==c*c  then $=$  '('a","   ||   b','c")"
          end   /*c*/
        end     /*b*/
      end       /*a*/

if 'f7'x==7  then do;  sup2='b2'x;  le='8c'x;  end                 /*EBCDIC ? */
             else do;  sup2='fd'x;  le='f3'x;  end                 /* ASCII ? */
say  'Pythagorean triples   (a'sup2 "+ b"sup2 '= c'sup2",   c "le n'):'
say;  say  strip($)                    /*show the Pythagorean triples to term.*/
say;  say  words($)  'members listed.' /*triples are listed in order of 1st #.*/
                                       /*stick a fork in it,  we're all done. */

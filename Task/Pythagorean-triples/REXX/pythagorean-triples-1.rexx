/*REXX program counts number of  Pythagorean triples  that exist given a max  */
/*────────── perimeter of  N, and also counts how many of them are primitives.*/
trips=0;   prims=0                     /*set the number of triples, primitives*/
parse arg N .;  if N==''  then n=100   /*N  specified?  No, then use default. */

  do a=3  to N%3;   aa=a*a             /*limit  side  to 1/3 of the perimeter.*/

     do b=a+1                          /*the triangle can't be isosceles.     */
     ab=a+b                            /*compute a partial perimeter (2 sides)*/
     if ab>=N  then iterate a          /*is  a+b ≥ perimeter?  Try different A*/
     aabb=aa+b*b                       /*compute the sum of  a²+b²  (shortcut)*/

        do c=b+1                       /*compute the value of the third side. */
        if ab+c>N     then iterate a   /*is  a+b+c > perimeter?  Try diff.  A.*/
        cc=c*c                         /*compute the value of  C².            */
        if cc > aabb  then iterate b   /*is  c² >  a²+b² ?  Try a different B.*/
        if cc\==aabb  then iterate     /*is  c² ¬= a²+b² ?  Try a different C.*/
        trips=trips+1                  /*eureka. We found a Pythagorean triple*/
        prims=prims+(gcd(a,b)==1)      /*is this  triple  a primitive triple? */
        end   /*c*/
     end      /*b*/
  end         /*a*/

_=left('',7)                           /*for padding the output with 7 blanks.*/
say 'max perimeter ='  N _ "Pythagorean triples ="  trips _ 'primitives =' prims
exit                                   /*stick a fork in it,  we're all done. */
/*────────────────────────────────────────────────────────────────────────────────────*/
gcd: procedure; parse arg x,y; do until y==0; parse value x//y y with y x; end; return x

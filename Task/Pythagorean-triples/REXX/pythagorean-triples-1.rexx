/*REXX program counts the number of  Pythagorean triples  that exist given a maximum    */
/*──────────────────── perimeter of  N, and also counts how many of them are primitives.*/
parse arg N .                                    /*obtain optional argument from the CL.*/
if N=='' | N==","  then n=100                    /*Not specified?  Then use the default.*/
T=0;  P=0                                        /*set the number of Triples, Primitives*/
              do a=3  to N%3;   aa=a*a           /*limit  side  to 1/3 of the perimeter.*/
                 do b=a+1                        /*the triangle can't be  isosceles.    */
                 ab=a + b                        /*compute a partial perimeter (2 sides)*/
                 if ab>=N  then iterate a        /*is  a+b ≥ perimeter?  Try different A*/
                 aabb=aa + b*b                   /*compute the sum of  a²+b²  (shortcut)*/
                    do c=b+1                     /*compute the value of the third side. */
                    if ab+c > N   then iterate a /*is  a+b+c > perimeter?  Try diff.  A.*/
                    cc=c*c                       /*compute the value of  C².            */
                    if cc > aabb  then iterate b /*is  c² >  a²+b² ?  Try a different B.*/
                    if cc\==aabb  then iterate   /*is  c² ¬= a²+b² ?  Try a different C.*/
                    T=T + 1                      /*eureka. We found a Pythagorean triple*/
                    P=P + (gcd(a, b)==1)         /*is this  triple  a primitive triple? */
                    end   /*c*/
                 end      /*b*/
              end         /*a*/
_=left('', 7)                                    /*for padding the output with 7 blanks.*/
say 'max perimeter ='    N   _    "Pythagorean triples ="    T    _    'primitives ='    P
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
gcd: procedure; parse arg x,y;  do until y==0; parse value x//y y with y x; end;  return x

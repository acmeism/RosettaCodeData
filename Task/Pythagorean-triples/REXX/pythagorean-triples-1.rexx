/*REXX pgm counts number of  Pythagorean triples that exist given a max */
/*   perimeter of  N,   and also counts how many of them are primitives.*/
trips=0;   prims=0                     /*zero # of triples, primatives. */
parse arg N .;  if N==''  then n=100   /*get "N".  If none, then assume.*/

  do a=3  to N%3;   aa=a*a             /*limit side to 1/3 of perimeter.*/

     do b=a+1                          /*triangle can't be isosceles.   */
     ab=a+b                            /*compute partial perimeter.     */
     if ab>=N  then iterate a          /*a+b≥perimeter?  Try different A*/
     aabb=aa+b*b                       /*compute sum of  a² + b² (cheat)*/

        do c=b+1                       /*3rd side:   also compute  c²   */
        if ab+c>N     then iterate a   /*a+b+c > perimeter?  Try diff A.*/
        cc=c*c                         /*compute  C².                   */
        if cc > aabb  then iterate b   /*c² >  a²+b² ?  Try different B.*/
        if cc\==aabb  then iterate     /*c² ¬= a²+b² ?  Try different C.*/
        trips=trips+1                  /*eureka.  We found a prim triple*/
        prims=prims+(gcd(a,b)==1)      /*is this  triple  a  primitive? */
        end   /*a*/
     end      /*b*/
  end         /*c*/

say 'max perimeter =' N,               /*show a single line of output.  */
    left('',7)  "Pythagorean triples =" trips,    /*left('',7)≡7 blanks.*/
    left('',7)  'primitives ='          prims
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────GCD subroutine──────────────────────*/
gcd: procedure; parse arg x,y
       do  until y==0; parse  value  x//y  y   with    y x; end;  return x

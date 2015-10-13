/*REXX program counts number of  Pythagorean triples  that exist given a max  */
/*REXX program counts number of  Pythagorean triples  that exist given a max  */
/*────────── perimeter of  N, and also counts how many of them are primitives.*/
@.=0;           trips=0;       prims=0 /*define some REXX variables to zero.  */
parse arg N .;  if N==''  then n=100   /*N  specified?  No, then use default. */

  do a=3  to N%3;   aa=a*a             /*limit  side  to 1/3 of the perimeter.*/
  aEven= a//2==0                       /*set variable to  1   if  A  is even. */

      do b=a+1  by 1+aEven             /*the triangle can't be isosceles.     */
      ab=a+b                           /*compute a partial perimeter (2 sides)*/
      if ab>=N  then iterate a         /*is  a+b ≥ perimeter?  Try different A*/
      aabb=aa+b*b                      /*compute the sum of  a²+b²  (shortcut)*/

         do c=b+1                      /*compute the value of the third side. */
         if aEven      then if c//2==0  then iterate
         if ab+c>n     then iterate a  /*a+b+c > perimeter?  Try different  A.*/
         cc=c*c                        /*compute the value of  C².            */
         if cc > aabb  then iterate b  /*is  c² >  a²+b² ?  Try a different B.*/
         if cc\==aabb  then iterate    /*is  c² ¬= a²+b² ?  Try a different C.*/
         if @.a.b.c    then iterate    /*Is this a duplicate?  Then try again.*/
         trips=trips+1                 /*Eureka! We found a Pythagorean triple*/
         prims=prims+1                 /*count this also as a primitive triple*/

            do m=2;   am=a*m;   bm=b*m;   cm=c*m    /*generate non-primitives.*/
            if am+bm+cm>N  then leave  /*is this multiple Pythagorean triple? */
            trips=trips+1              /*Eureka! We found a Pythagorean triple*/
            @.am.bm.cm=1               /*mark Pythagorean triangle as a triple*/
            end   /*m*/
         end      /*c*/
      end         /*b*/
  end             /*a*/

_=left('',7)                           /*for padding the output with 7 blanks.*/
say 'max perimeter ='  N _ "Pythagorean triples ="  trips _ 'primitives =' prims
                                       /*stick a fork in it,  we're all done. */

/*REXX pgm counts number of  Pythagorean triples that exist given a max */
/*   perimeter of  N,   and also counts how many of them are primatives.*/
@.=0;           trips=0;       prims=0
parse arg N .;  if N==''  then n=100   /*get "N".  If none, then assume.*/

  do a=3 to N%3;   aa=a*a              /*limit side to 1/3 of perimeter.*/
  aEven=a//2==0

      do b=a+1  by 1+aEven             /*triangle can't be isosceles.   */
      ab=a+b                           /*compute partial perimeter.     */
      if ab>=n then iterate a          /*a+b>perimeter?  Try different A*/
      aabb=aa+b*b                      /*compute sum of  a² + b² (cheat)*/

         do c=b+1;   cc=c*c            /*3rd side:   also compute  c²   */
         if aEven then if c//2==0 then iterate
         if ab+c>n     then iterate a  /*a+b+c > perimeter?  Try diff A.*/
         if cc>aabb    then iterate b  /*c² >  a²+b² ?  Try different B.*/
         if cc\==aabb  then iterate    /*c² ¬= a²+b² ?  Try different C.*/
         if @.a.b.c then iterate
         trips=trips+1                 /*eureka.                        */
         prims=prims+1                 /*count this primitive triple.   */

            do m=2;   !a=a*m;   !b=b*m;   !c=c*m   /*gen non-primitives.*/
            if !a+!b+!c>N then leave   /*is this multiple a triple ?    */
            trips=trips+1              /*yuppers, then we found another.*/
            if m//2 then @.!a.!b.!c=1  /*don't mark if an even multiple.*/
            end  /*m*/
         end     /*d*/
      end        /*b*/
  end            /*a*/

say 'max perimeter = 'N,               /*show a single line of output.  */
    left('',7) "Pythagorean triples =" trips,   /*left('',0) = 7 blanks.*/
    left('',7) 'primitives =' prims
                                       /*stick a fork in it, we're done.*/

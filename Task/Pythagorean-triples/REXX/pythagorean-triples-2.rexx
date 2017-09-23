/*REXX program counts the number of  Pythagorean triples  that exist given a maximum    */
/*──────────────────── perimeter of  N, and also counts how many of them are primitives.*/
parse arg N .                                    /*obtain optional argument from the CL.*/
if N=='' | N==","  then n=100                    /*Not specified?  Then use the default.*/
T=0;   P=0                                       /*set the number of Triples, Primitives*/
@.=0;         do a=3  to N%3;   aa=a*a           /*limit  side  to 1/3 of the perimeter.*/
              aEven= a//2==0                     /*set variable to  1   if  A  is even. */
                do b=a+1  by 1+aEven             /*the triangle can't be isosceles.     */
                ab=a + b                         /*compute a partial perimeter (2 sides)*/
                if ab>=N  then iterate a         /*is  a+b ≥ perimeter?  Try different A*/
                aabb=aa + b*b                    /*compute the sum of  a²+b²  (shortcut)*/
                  do c=b + 1                     /*compute the value of the third side. */
                  if aEven      then if c//2==0  then iterate
                  if ab+c>n     then iterate a   /*a+b+c > perimeter?  Try different  A.*/
                  cc=c*c                         /*compute the value of  C².            */
                  if cc > aabb  then iterate b   /*is  c² >  a²+b² ?  Try a different B.*/
                  if cc\==aabb  then iterate     /*is  c² ¬= a²+b² ?  Try a different C.*/
                  if @.a.b.c    then iterate     /*Is this a duplicate?  Then try again.*/
                  T=T + 1                        /*Eureka! We found a Pythagorean triple*/
                  P=P + 1                        /*count this also as a primitive triple*/
                    do m=2  while a*m+b*m+c*m<=N /*generate non-primitives Pythagoreans.*/
                    T=T + 1                      /*Eureka! We found a Pythagorean triple*/
                    am=a*m;    bm=b*m;    cm=c*m /*create some short-cut variable names.*/
                    @.am.bm.cm=1                 /*mark Pythagorean triangle as a triple*/
                    end   /*m*/
                  end     /*c*/
                end       /*b*/
              end         /*a*/
_=left('', 7)                                    /*for padding the output with 7 blanks.*/
say 'max perimeter ='    N   _    "Pythagorean triples ="    T    _    'primitives ='    P
                                                 /*stick a fork in it,  we're all done. */

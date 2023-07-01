/*REXX program determines if a number (in base 10)  is a  self─describing,              */
/*──────────────────────────────────────────────────────  self─descriptive,             */
/*──────────────────────────────────────────────────────  autobiographical,   or a      */
/*──────────────────────────────────────────────────────  curious  number.              */
parse arg x y .                                  /*obtain optional arguments from the CL*/
if x=='' | x==","  then exit                     /*Not specified?  Then get out of Dodge*/
if y=='' | y==","  then y=x                      /* "      "       Then use the X value.*/
w=length(y)                                      /*use  Y's  width for aligned output.  */
numeric digits max(9, w)                         /*ensure we can handle larger numbers. */
if x==y  then do                                 /*handle the case of a single number.  */
              noYes=test_SDN(y)                  /*is it  or  ain't it?                 */
              say y  word("is isn't", noYes+1)  'a self-describing number.'
              exit
              end

         do n=x  to  y
         if test_SDN(n)  then iterate            /*if not self─describing,  try again.  */
         say  right(n,w)  'is a self-describing number.'                       /*is it? */
         end   /*n*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
test_SDN: procedure; parse arg ?;    L=length(?) /*obtain the argument  and  its length.*/
                    do j=L  to 1  by -1          /*parsing backwards is slightly faster.*/
                    if substr(?,j,1)\==L-length(space(translate(?,,j-1),0))  then return 1
                    end   /*j*/
          return 0                               /*faster if used inverted truth table. */

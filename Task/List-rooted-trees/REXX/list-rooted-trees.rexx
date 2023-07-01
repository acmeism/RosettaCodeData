/*REXX program lists  n─node  rooted trees  (by enumerating all ways of nesting N bags).*/
parse arg N .                                    /*obtain optional argument from the CL.*/
if N=='' | N==","  then N=5                      /*Not specified?  Then use the default.*/
if N>5  then do;  say N  "isn't supported for this program at this time.";   exit 13;  end
nn= N + N - 1                                    /*power of 2 that is used for dec start*/
numeric digits 200                               /*use enough digs for next calculation.*/
numeric digits max(9, 1 + length( x2b( d2x(2**(nn+1) - 1) ) ) )  /*limit decimal digits.*/
start= 2**nn    +    (2**nn) % 2                 /*calculate the starting decimal number*/
if N==1  then start= 2**1                        /*treat the start for unity as special.*/
@= copies('─', 20)"► ";    o = 'o'               /*demonstrative literal for solutions. */
#= 0                                             /*count of ways to nest bags (so far). */
$=                                               /*string holds possible duplicious strs*/
    do j=start + start//2  to 2**(nn+1)-1  by 2  /*limit the search, smart start and end*/
    t= x2b( d2x(j) )   +   0                     /*convert dec number to a binary string*/
    z= length( space( translate(t, , 0), 0) )    /*count the number of zeros in bit str.*/
    if z\==n  then iterate                       /*Not enough zeroes?  Then skip this T.*/
    if N>1  then if  left(t, N)==right(t, N)  then iterate     /*left side ≡ right side?*/
    if N>2  then if right(t, 2)==    10  then iterate  /*has a right─most isolated bag ?*/
    if N>3  then if right(t, 4)==  1100  then iterate  /* "  "      "         "     "   */
    if N>4  then if right(t, 6)==111000  then iterate  /* "  "      "         "     "   */
    if N>4  then if right(t, 6)==110100  then iterate  /* "  "      "         "     "   */
    if N>4  then if right(t, 6)==100100  then iterate  /* "  "      "         "     "   */
    if wordpos(t, $)\==0                 then iterate  /*this a duplicate bag stuffing? */
    say @ changestr('()', translate(t, "()", 10),  o)  /*show a compact display with oh.*/
    #= # + 1                                     /*bump count of ways of nesting bags.  */
    $= $  translate( reverse(t), 01, 10)         /*save a (possible) duplicious string. */
    end   /*j*/
say                                              /*separate number─of─ways with a blank.*/
say # ' is the number of ways to nest' n "bags." /*stick a fork in it,  we're all done. */

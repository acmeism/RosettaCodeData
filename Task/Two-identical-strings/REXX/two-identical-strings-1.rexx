/*REXX
 * program finds/displays decimal numbers
 * whose binary version is a doubled literal.
 */
numeric digits 20        /*ensure 'nuff dec. digs for conversion*/
do i=1 to 1000
  b= x2b( d2x(i) ) + 0  /*find binary values that can be split.*/
  L= length(b)
  if L//2  then iterate /*get length of binary;  if odd, skip. */
  if left(b, L%2)\==right(b, L%2)  then iterate /*Left half ≡ right half?*/
  say right(i, 4)':'   right(b, 12)      /*display number in dec and bin */
end   /*i*/            /*stick a fork in it,  we're all done. */
*/

/*REXX pgm generates & displays the Thue─Morse sequence up to the Nth term (inclusive). */
parse arg N .                                    /*obtain the optional argument from CL.*/
if N=='' | N==","  then N= 80                    /*Not specified?  Then use the default.*/
$=                                               /*the Thue─Morse sequence  (so far).   */
         do j=0  to N                            /*generate sequence up to the Nth item.*/
         $= $ || $weight(j) // 2                 /*append the item to the Thue─Morse seq*/
         end   /*j*/
say $
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
$pop:    return  length( space( translate( arg(1), , 0), 0) )     /*count 1's in number.*/
$weight: return  $pop( x2b( d2x( arg(1) ) ) )                     /*dec──►bin, pop count*/

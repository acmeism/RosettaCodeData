/*REXX pgm calculates the  de Bruijn  sequence for all pin numbers  (4 digit decimals). */
$=                                               /*initialize the  de Bruijn  sequence. */
   do j=0  for 10;  $= $ j;   jj= j || j          /*compose the left half of the numbers.*/
  $$= space($, 0)                                /* [↓]     "  right  "   "  "     "    */
                                do k=jj+1  to 99;      z= jj || right(k, 2, 0)
                                if pos(z, $$)\==0  then iterate /*# in sequence? Skip it*/
                                $= $ z           /* ◄─────────────────────────────────┐ */
                                end   /*k*/      /*append a number to the sequence──◄─┘ */
  $$= space($, 0)
     do r= jj  to (j || 9);  b= right(r, 2, 0)   /*compose the left half of the numbers.*/
     if b==jj  then iterate
     $= $ right(b, 2, 0)                         /* [↓]     "  right  "   "  "     "    */
     $$= space($, 0);           do k= b+1  to 99;      z= right(b, 2, 0) || right(k, 2, 0)
                                if pos(z, $$)\==0  then iterate /*# in sequence? Skip it*/
                                $= $ z           /* ◄─────────────────────────────────┐ */
                                end   /*k*/      /*append a number to the sequence──◄─┘ */
     $$= space($, 0)
     end   /*r*/
  end      /*j*/

$= delword($, words($)-4, 1)                     /*delete 5th from the last word in $.  */
$= space($, 0)
                      @deB= 'de Bruijn sequence' /*literal used in some SAY instructions*/
$= $ || left($, 3)        /*append 000*/         /*simulate "wrap-around" de Bruijn seq.*/
       say 'length of the' @deB " is " length($) /*display the length of  de Bruijn seq.*/
say;   say 'first 130 digits of the' @deB":"     /*display the title for the next line. */
       say left($, 130)                          /*display 130 left-most digits of seq. */
say;   say ' last 130 digits of the' @deB":"     /*display the title for the next line. */
       say right($, 130)                         /*display 130 right-most digits of seq.*/
call val $                                       /*call the  VAL  sub for verification. */
               @deB= 'reversed'   @deB           /*next,  we'll check on a reversed seq.*/
$r= reverse($)                                   /*do what a mirror does,  reversify it.*/
call val $r                                      /*call the  VAL  sub for verification. */
$= overlay(., $, 4444)                           /*replace 4,444th digit with a period. */
               @deB= 'overlaid' subword(@deB, 2) /* [↑] this'll cause a validation barf.*/
call val $                                       /*call the  VAL  sub for verification. */
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
val: parse arg $$$;    e= 0;    _= copies('─',8) /*count of errors (missing PINs) so far*/
     say;      say _ 'validating the'    @deB"." /*display what's happening in the pgm. */
         do pin=0  for 1e4; pin4= right(pin,4,0) /* [↓]  maybe add leading zeros to pin.*/
         if pos(pin4, $$$)\==0  then iterate     /*Was number found?  Just as expected. */
         say 'PIN number '      pin       " wasn't found in"         @deb'.'
         e= e + 1                                /*bump the counter for number of errors*/
         end   /*pin*/                           /* [↑]  validate all 10,000 pin numbers*/
     if e==0  then e= 'No'                       /*Gooder English (sic) the error count.*/
     say _   e   'errors found.'                 /*display the number of errors found.  */
     return

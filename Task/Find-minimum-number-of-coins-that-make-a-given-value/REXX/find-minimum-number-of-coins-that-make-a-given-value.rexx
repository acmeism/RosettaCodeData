/*REXX pgm finds & displays the minimum number of coins which total to a specified value*/
parse arg $ coins                                /*obtain optional arguments from the CL*/
if     $='' |     $=","  then     $= 988         /*Not specified?  Then use the default.*/
if coins='' | coins=","  then coins= 1 2 5 10 20 50 100 200 /* ...   "   "   "     "    */
#= words(coins)                                  /*#:  is the number of allowable coins.*/
w= 0                                             /*width of largest coin (for alignment)*/
        do j=1  for #;   @.j= word(coins, j)     /*assign all coins to an array  (@.).  */
        w= max(w, length(@.j) )                  /*find the width of the largest coin.  */
        end   /*j*/
say 'available coin denominations: '   coins     /*shown list of available denominations*/
say
say center(' making change for '  $, 30     )    /*display title for the upcoming output*/
say center(''                      , 30, "─")    /*   "     sep   "   "     "        "  */
koins= 0                                         /*the total number of coins dispensed. */
paid= 0                                          /*the total amount of money paid so far*/
        do k=#  by -1  for #;  z= $ % @.k        /*start with largest coin for payout.  */
        if z<1  then iterate                     /*if Z is not positive, then skip coin.*/
        koins= koins + z
        paid= z * @.k                            /*pay out a number of coins.           */
        $= $ - paid                              /*subtract the pay─out from the $ total*/
        say right(z,9) ' of coin ' right(@.k, w) /*display how many coins were paid out.*/
        end   /*k*/

say center(''                      , 30, "─")    /*   "     sep   "   "     "        "  */
say
say 'number of coins dispensed: '  koins
if $>0  then say 'exact payout not possible.'    /*There a residue?  Payout not possible*/
exit 0                                           /*stick a fork in it,  we're all done. */

/*REXX program  displays  lyrics  to the song  "99 Bottles of Beer on the Wall".        */
parse arg N .;         if N=='' | N==","  then N=99   /*let number of bottles be given. */

        do j=N  by -1  to 1                           /*start the countdown and singdown*/
        say j 'bottle's(j) "of beer on the wall,"     /*sing the number bottles of beer.*/
        say j 'bottle's(j) "of beer."                 /*    ···  and the song's refrain.*/
        say 'Take one down, pass it around,'          /*take a beer bottle and share it.*/
        m=j-1                                         /*M: number of bottles we have now*/
        if m==0  then m='no'                          /*use  "no"  instead of numeric 0.*/
        say m 'bottle's(m) "of beer on the wall."     /*sing the beer bottle inventory. */
        say                                           /*a blank line between the verses.*/
        end   /*j*/
                                                      /*Not quite tanked?  Then sing it.*/
say 'No more bottles of beer on the wall,'            /*Finally!   The last verse.      */
say 'no more bottles of beer.'                        /*this is so forlorn ···          */
say 'Go to the store and buy some more,'              /*obtain replenishment of the beer*/
say N  'bottles of beer on the wall.'                 /*all is well in the ole tavern.  */
exit                                                  /*we're all done and also sloshed.*/
/*──────────────────────────────────────────────────────────────────────────────────────*/
s:  if arg(1)=1  then return '';  return 's'          /*a simple  pluralizer  function. */

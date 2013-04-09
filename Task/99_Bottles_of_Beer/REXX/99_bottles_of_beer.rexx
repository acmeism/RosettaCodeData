/*REXX pgm displays words to the song "99 Bottles of Beer on the Wall". */

  do j=99 by -1 to 1                        /*start countdown | singdown*/
  say j 'bottle's(j) "of beer on the wall," /*sing the #bottles of beer.*/
  say j 'bottle's(j) "of beer."             /* ... and the refrain.     */
  say 'Take one down, pass it around,'      /*get a bottle and share it.*/
  n=j-1                                     /*N is #bottles we have now.*/
  if n==0 then n='no'                       /*use  "no"  instead of  0. */
  say n 'bottle's(n) "of beer on the wall." /*sing beer bottle inventory*/
  say                                       /*blank line between verses.*/
  end   /*j*/

say 'No more bottles of beer on the wall,'  /*Finally!   The last verse.*/
say 'no more bottles of beer.'              /*so sad ...                */
say 'Go to the store and buy some more,'    /*replenishment of the beer.*/
say '99 bottles of beer on the wall.'       /*All is well in the tavern.*/
exit                                        /*we're done & also sloshed.*/
/*───────────────────────────────────S subroutine───────────────────────*/
s: if arg(1)=1 then return ''; return 's'   /*a simple pluralizer funct.*/

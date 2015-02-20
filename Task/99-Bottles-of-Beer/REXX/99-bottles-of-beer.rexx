/*REXX pgm displays lyrics to the song "99 Bottles of Beer on the Wall".*/
parse arg N .;   if N==''  then N=99        /*let # bottles be specified*/

  do j=N  by -1  to 1                       /*start countdown & singdown*/
  say j 'bottle's(j) "of beer on the wall," /*sing the #bottles of beer.*/
  say j 'bottle's(j) "of beer."             /*     ···  and the refrain.*/
  say 'Take one down, pass it around,'      /*get a bottle and share it.*/
  m=j-1                                     /*M:  # bottles we have now.*/
  if m==0  then m='no'                      /*use  "no"  instead of  0. */
  say m 'bottle's(m) "of beer on the wall." /*sing beer bottle inventory*/
  say                                       /*blank line between verses.*/
  end   /*j*/
                                            /*Not tanked?  Then sing it.*/
say 'No more bottles of beer on the wall,'  /*Finally!   The last verse.*/
say 'no more bottles of beer.'              /*this is so forlorn ···    */
say 'Go to the store and buy some more,'    /*replenishment of the beer.*/
say N  'bottles of beer on the wall.'       /*all is well in the tavern.*/
exit                                        /*we're done & also sloshed.*/
/*───────────────────────────────────S subroutine───────────────────────*/
s: if arg(1)=1  then return '';  return 's' /*simple pluralizer function*/

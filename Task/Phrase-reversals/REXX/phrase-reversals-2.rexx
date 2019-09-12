/*REXX program reverses  words and also letters  in a string in various (several) ways. */
parse arg $                                      /*obtain optional arguments from the CL*/
if $=''  then $= "rosetta code phrase reversal"  /*Not specified?  Then use the default.*/
L=;  W=                                          /*initialize two REXX variables to null*/
           do j=1  for words($);   _= word($, j) /*extract each word in the  $  string. */
           L= L reverse(_);        W= _ W        /*reverse letters;  reverse words.     */
           end   /*j*/
say '   the original phrase used: '          $
say '   original phrase reversed: '  reverse($)
say '  reversed individual words: '    strip(L)
say '  reversed words in phrases: '          W   /*stick a fork in it,  we're all done. */

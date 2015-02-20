/*REXX pgm reverses  words and/or letters  in a string in various ways. */
i=; p=;  parse arg $;  if $=''  then $="rosetta code phrase reversal"
                                       do j=1  for words($);   _=word($,j)
                                       i=i reverse(_)      ;   p=_ p
                                       end   /*j*/
say ' the original phrase used: '  $
say ' original phrase reversed: '  reverse($)
say 'reversed individual words: '  strip(i)
say 'reversed words in phrases: '  p   /*stick a fork in it, we're done.*/

u= 'Halloween'                                   /*word to be sorted by (Latin)  letter.*/
upper u                                          /*fast method to uppercase a variable. */
L=length(u)                                      /*get the length of the word (in bytes)*/
say 'u=' u
say 'L=' L
_.=
       do k=1  for L                             /*keep truckin'  for   L   characters. */
       parse var u =(k) y +1                     /*get the  Kth  character in  U string.*/
       xx='?'y                                   /*assign a prefixed character to   XX. */
       _.xx=_.xx || y                            /*append it to all the  Y  characters. */
       end   /*do k*/                            /*U now has the first character elided.*/

                                                 /* [↓]  construct a sorted letter word.*/

z=_.?a||_.?b||_.?c||_.?d||_.?e||_.?f||_.?g||_.?h||_.?i||_.?j||_.?k||_.?l||_.?m||,
  _.?n||_.?o||_.?p||_.?q||_.?r||_.?s||_.?t||_.?u||_.?v||_.?w||_.?x||_.?y||_.?z

say 'z=' z

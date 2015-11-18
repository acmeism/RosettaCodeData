u='Halloween'                          /*the word to be sorted by letter*/
upper u                                /*fast method to uppercase a var.*/
L=length(u)                            /*get the length of the word.    */
say 'u=' u
say 'L=' L
_.=
       do k=1  for L                   /*keep truckin'  for  L  chars.  */
       parse var u =(k) y +1           /*get Kth character in U string. */
       xx = '?'y                       /*assign a prefixed char to  XX. */
       _.xx = _.xx || y                /*append it to all the  Y  chars.*/
       end   /*do k*/                  /*U  now has the first char gone.*/

                                       /* [↓] build sorted letter word. */

z=_.?a||_.?b||_.?c||_.?d||_.?e||_.?f||_.?g||_.?h||_.?i||_.?j||_.?k||_.?l||_.?m||,
  _.?n||_.?o||_.?p||_.?q||_.?r||_.?s||_.?t||_.?u||_.?v||_.?w||_.?x||_.?y||_.?z

say 'z=' z

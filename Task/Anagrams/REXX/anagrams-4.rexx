u='Halloween'                          /*the word to be sorted by letter*/
upper u                                /*fast method to uppercase a var.*/
                                       /*another:     u = translate(u)  */
                                       /*another:   parse upper var u u */
                                       /*another:        u = upper(u)   */
                                       /*not always available [↑]       */
say 'u=' u
_.=
       do  until  u==''                /*keep truckin' until  U is null.*/
       parse var u y +1 u              /*get the next (first) char in U.*/
       xx = '?'y                       /*assign a prefixed char to  XX. */
       _.xx = _.xx || y                /*append it to all the  Y  chars.*/
       end   /*until*/                 /*U  now has the first char gone.*/
                                       /*Note: the var  U  is destroyed.*/

                                       /* [↓] build sorted letter word. */

z=_.?a||_.?b||_.?c||_.?d||_.?e||_.?f||_.?g||_.?h||_.?i||_.?j||_.?k||_.?l||_.?m||,
  _.?n||_.?o||_.?p||_.?q||_.?r||_.?s||_.?t||_.?u||_.?v||_.?w||_.?x||_.?y||_.?z

                   /*Note:  the  ?  is prefixed to the letter to avoid  */
                   /*collisions with other REXX one-character variables.*/
say 'z=' z

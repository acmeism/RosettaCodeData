u= 'Halloween'                                   /*word to be sorted by (Latin)  letter.*/
upper u                                          /*fast method to uppercase a variable. */
                                                 /*another:       u = translate(u)      */
                                                 /*another:       parse upper var u u   */
                                                 /*another:       u = upper(u)          */
                                                 /*not always available [↑]             */
say 'u=' u
_.=
       do  until  u==''                          /*keep truckin' until  U  is  null.    */
       parse var u y +1 u                        /*get the next (first) character in  U.*/
       xx='?'y                                   /*assign a prefixed character to   XX. */
       _.xx=_.xx || y                            /*append it to all the  Y  characters. */
       end   /*until*/                           /*U now has the first character elided.*/
                                                 /*Note:  the variable  U  is destroyed.*/

                                                 /* [↓]  constructs a sorted letter word*/

z=_.?a||_.?b||_.?c||_.?d||_.?e||_.?f||_.?g||_.?h||_.?i||_.?j||_.?k||_.?l||_.?m||,
  _.?n||_.?o||_.?p||_.?q||_.?r||_.?s||_.?t||_.?u||_.?v||_.?w||_.?x||_.?y||_.?z

                                   /*Note:  the  ?  is prefixed to the letter to avoid  */
                                   /*collisions with other REXX one-character variables.*/
say 'z=' z

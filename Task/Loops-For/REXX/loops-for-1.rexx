/*REXX program demonstrates an outer DO loop controlling the inner DO loop with a "FOR".*/

       do j=1  for 5                             /*this is the same as:   do j=1  to 5  */
       $=                                        /*initialize the value to a null string*/
              do k=1  for j                      /*only loop for a   J   number of times*/
              $= $ || '*'                        /*using concatenation  (||)  for build.*/
              end   /*k*/
       say $                                     /*display character string being built.*/
       end          /*j*/                        /*stick a fork in it,  we're all done. */

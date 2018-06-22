/*REXX program prompts & reads/obtains a string, and also the number 75000 from terminal*/
say 'Please enter a string:'                     /*issue a prompt message to the term.  */
parse pull userString                            /*the (char) string can be any length. */
                                                 /* [↑]  the string could be null/empty.*/
  do  until userNumber=75000                     /*repeat this loop until satisfied.    */
  say                                            /*display a blank line to the terminal.*/
  say 'Please enter the number 75000'            /*display a nice prompt message to term*/
  parse pull userNumber                          /*obtain the user text from terminal.  */
  end   /*until*/                                /*check if the response is legitimate. */
                                                 /*stick a fork in it,  we're all done. */

/*REXX pgm prompts and gets a string and also the # 75000 from terminal.*/
say 'Please enter a string:';     parse  pull userString
say 'You entered this string:' userString /* show it on the console     */
                                       /* [↑]  string can be any length.*/
  do  until userNumber=75000           /*repeat this loop until correct.*/
  say                                  /*display blank line to terminal.*/
  say 'Please enter the number 75000'  /*display a nice prompt message. */
  parse pull userNumber                /*obtain the user text from term.*/
  end   /*until ··· */                 /*check if the response is legit.*/
                                       /*stick a fork in it, we're done.*/

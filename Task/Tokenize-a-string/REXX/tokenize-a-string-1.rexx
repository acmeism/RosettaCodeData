/*REXX program separates a string of comma─delimited words, and echoes them ──► terminal*/
original = 'Hello,How,Are,You,Today'             /*some words separated by commas (,).  */
say  'The input string:'  original               /*display original string ──► terminal.*/
new= original                                    /*make a copy of the string.           */
                 do #=1  until  new==''          /*keep processing until  NEW  is empty.*/
                 parse var  new   @.#  ','  new  /*parse words delineated by a comma (,)*/
                 end   /*#*/                     /* [↑]  the new array is named   @.    */
say                                              /* NEW  is destructively parsed.   [↑] */
say center(' Words in the string ', 40, "═")     /*display a nice header for the list.  */
                 do j=1  for #                   /*display all the words (one per line),*/
                 say @.j || left(., j\==#)       /*maybe append a period (.) to a word. */
                 end   /*j*/                     /* [↑]  don't append a period if last. */
say center(' End─of─list ', 40, "═")             /*display a (EOL) trailer for the list.*/

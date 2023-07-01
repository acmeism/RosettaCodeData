/*REXX program saves the screen contents and also the cursor location,  then clears the */
/*──── screen, writes a half screen of ~~~ lines, and then restores the original screen.*/

parse value  scrsize()   with  sd  sw  .         /*determine the size of terminal screen*/
parse value cursor(1,1)  with  curRow  curCol .  /*also, find the location of the cursor*/

          do original=1  for sd                  /*obtain the original screen contents. */
          @line.original=scrRead(original,1, sw) /*obtain a line of the terminal screen.*/
          end   /*original*/                     /* [↑]  obtains  SD  number of lines.  */
'CLS'                                            /*start with a clean slate on terminal.*/
          do sd % 2                              /*write a line of ~~~ for half of scr. */
          say '~~~'                              /*writes ~~~ starting at top of screen.*/
          end   /*sd % 2*/                       /* [↑]  this shows ~~~ will be overlaid*/
                                                 /*no need to clear the screen here.    */
          do restore=1  for sd                   /*restore original screen from  @line. */
          call scrWrite restore,1, @line.restore /*write to terminal the original lines.*/
          end   /*restore*/                      /* [↑]  writes (restores)  SD  lines.  */
                                                 /*stick a fork in it,  we're all done. */
call cursor  curRow, curCol                      /*restore the original cursor position.*/

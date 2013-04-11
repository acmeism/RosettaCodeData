/*REXX pgm saves the screen contents, clear it, write +++, restore orig.*/
parse value scrsize() with sd sw .     /*determine how big the screen is*/
parse value cursor(1,1) with r_ c_     /*find where the cursor is also. */
             do original=1 for sd      /*get the original screen content*/
             @line.original=scrread(original,1,sw)
             end
'CLS'                                  /*start with a clean slate.      */
             do 20
             say copies('$',60)        /*write a score of sixty bucks.  */
             end
'CLS'                                  /*start with a clean slate, again*/
             do restore=1 for sd       /*restore the original screen.   */
             call scrwrite restore,1,strip(@line.restore,'T')
             end
call cursor r_,c_                      /*restore the original cursor pos*/
                                       /*stick a fork in it, we're done.*/

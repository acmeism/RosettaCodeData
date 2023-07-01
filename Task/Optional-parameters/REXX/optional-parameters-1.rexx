sortStrings:  procedure expose @.                /*the stemmed array is named:    @.    */
col= 1                                           /*set some defaults  (here and below). */
reverse= 'NO'
order= 'LEXICOGRAPHIC'
arg options                                      /*obtain the options  (in uppercase).  */
               do j=1  for words(options)        /*examine all the words (options).     */
               x= word(options, j)
                    select
                    when datatype(x, 'W')  then col= x / 1      /*normalize the number. */
                    when pos('=', x)==0    then order= x        /*has it an equal sign? */
                    otherwise                   parse var x nam '=' value   /*get value.*/
                    end   /*select*/
               end        /*j*/

                         /*╔═══════════════════════════════════════════════════════════╗
                           ║ check for errors here:  COL isn't a positive integer ···, ║
                           ║                         REVERSE value isn't  NO  or  YES, ║
                           ║                         ORDER   value is recognized ···   ║
                           ╚═══════════════════════════════════════════════════════════╝*/

       ... main body of string sort here ...

return                                           /*stick a fork in it,  we're all done. */

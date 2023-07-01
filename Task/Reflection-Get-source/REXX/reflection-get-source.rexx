/*REXX program gets the source function (source code) and */
/*───────────────────────── displays the number of lines. */
#=sourceline()
                do j=1  for sourceline()
                say 'line'  right(j, length(#) )  '──►'   ,
                            strip( sourceline(j), 'T')
                end   /*j*/
say
parse source x y sID
say  'The name of the  source file (program) is: '    sID
say  'The number of lines in the source program: '     #
                     /*stick a fork in it, we're all done.*/

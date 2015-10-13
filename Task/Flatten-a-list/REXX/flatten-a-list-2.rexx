/*REXX pgm demonstrates how to flatten a list  (it need not be numeric). */
y = '[[1], 2, [[3,4], 5], [[[]]], [[[6]]], 7, 8, []]'

z = translate( y, ,'[,]' )             /*change brackets&commas──►blanks.*/
z = space(z)                           /*remove any extraneous blanks.   */
z = changestr( ' ', z, ", " )          /*change blanks to "comma blank". */
z = '[' || z || "]"                    /*add brackets via concatenation. */

                                       /*alternate of the above statement*/
                                       /*  (add brackets via abutment)   */

                                       /* ╔════════════════════════════╗ */
                                       /* ║         z = '['z"]"        ║ */
                                       /* ╚════════════════════════════╝ */
say ' input =' y
say 'output =' z
                                       /*stick a fork in it,  we're done.*/

/*REXX program demonstrates removal of 1st/last/1st&last chars from a string. */
@ = 'abcdefghijk'
say '                  the original string ='  @
say 'string first        character removed ='  substr(@,2)
say 'string         last character removed ='  left(@,length(@)-1)
say 'string first & last character removed ='  substr(@,2,length(@)-2)
                                       /*stick a fork in it,  we're all done. */

                 /* ╔═══════════════════════════════════════════════════════╗
                    ║  However, the original string may be null or exactly  ║
                    ║  one byte in length   which  will cause the  BIFs to  ║
                    ║  fail because of  either zero  or  a negative length. ║
                    ╚═══════════════════════════════════════════════════════╝ */

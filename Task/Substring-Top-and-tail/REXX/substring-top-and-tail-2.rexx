/*REXX program demonstrates removal of 1st/last/1st&last chars from a string. */
@ = 'abcdefghijk'
say '                  the original string ='  @
say 'string first        character removed ='  substr(@,2)
say 'string         last character removed ='  left(@,max(0,length(@)-1))
say 'string first & last character removed ='  substr(@,2,max(0,length(@)-2))
exit                                   /*stick a fork in it,  we're all done. */

                    /* [↓]  an easier to read version using a length variable.*/
@ = 'abcdefghijk'
L=length(@)
say '                  the original string ='  @
say 'string first        character removed ='  substr(@,2)
say 'string         last character removed ='  left(@,max(0,L-1))
say 'string first & last character removed ='  substr(@,2,max(0,L-2))

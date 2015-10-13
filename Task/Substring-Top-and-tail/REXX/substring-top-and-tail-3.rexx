/*REXX program demonstrates removal of 1st/last/1st&last chars from a string. */
@ = 'abcdefghijk'
say '                  the original string =' @

parse var @ 2 z
say 'string first        character removed =' z

m=length(@)-1
parse var @ z +(m)
say 'string         last character removed =' z

n=length(@)-2
parse var @ 2 z +(n)
if n==0  then z=                       /*handle special case of a length of 2.*/
say 'string first & last character removed =' z
                                       /*stick a fork in it,  we're all done. */

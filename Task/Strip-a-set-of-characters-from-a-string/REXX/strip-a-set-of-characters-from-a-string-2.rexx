/*REXX program to remove a set of characters from a string  (haystack). */
say stripChars('She was a soul stripper. She took my heart!', "iea")
exit                                   /*stick a fork in it, we're done.*/
/*───────────────────────────────────STRIPCGARS subroutine──────────────*/
stripChars: procedure;  parse arg haystack, remove
                     do j=1 for length(remove)
                     haystack=changestr(substr(remove,j,1), haystack, '')
                     end   /*j*/
return haystack

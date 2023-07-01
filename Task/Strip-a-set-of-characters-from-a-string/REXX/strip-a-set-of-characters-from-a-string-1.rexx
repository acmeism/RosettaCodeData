/*REXX program  removes  a list of characters from a string  (the haystack).            */
say stripChars('She was a soul stripper. She took my heart!',   "iea")     /*elide: iea */
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
stripChars: procedure;  parse arg haystack, remove
                                do j=1  for length(remove)
                                haystack=changestr( substr( remove, j, 1),  haystack, '')
                                end   /*j*/
            return haystack

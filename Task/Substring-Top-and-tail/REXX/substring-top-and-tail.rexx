/*REXX program to show removal of 1st/last/1st&last chars from a string.*/
z = 'abcdefghijk'

say '                  the original string =' z
say 'string first        character removed =' substr(z,2)
say 'string         last character removed =' left(z,length(z)-1)
say 'string first & last character removed =' substr(z,2,length(z)-2)
exit
        /* ┌───────────────────────────────────────────────┐
           │ however, the original string may be null,     │
           │ or of insufficient length which may cause the │
           │ BIFs to fail  (because of negative length).   │
           └───────────────────────────────────────────────┘ */

say '                  the original string =' z
say 'string first        character removed =' substr(z,2)
say 'string         last character removed =' left(z,max(0,length(z)-1))
say 'string first & last character removed =' substr(z,2,max(0,length(z)-2))
                            /*stick a fork in it,we're done.*/

/*REXX program demonstrates  hashing  of a stemmed array  (from a key). */
                                       /*names of the 9 regular polygons*/
values='triangle quadrilateral pentagon hexagon heptagon octagon nonagon decagon dodecagon'
keys  ='thuhree  vour          phive    sicks   zeaven   ate     nein    den     duzun'
                           /* [↑]  superfluous blanks added to humorous */
                           /*      keys just because it looks prettier. */
call hash values,keys                 /*nothing, then let's leave Dodge*/ /*hash the keys to the values.   */
parse arg query .                      /*get what was specified on C.L. */
if query==''  then exit                /*Nothing?  Then leave Dodge City*/
pad=left('',30)                        /*used for padding the display.  */
say  'key:'   query   pad   "value:"   hash.query     /*show some stuff.*/
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────HASH subroutine─────────────────────*/
hash: procedure expose hash.;   parse arg v,k,hash.
            do j=1  until map=='';            map=word(k,j)
                                         hash.map=word(v,j)
            end   /*j*/
return

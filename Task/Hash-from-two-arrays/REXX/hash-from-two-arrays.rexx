/*REXX program demonstrate  hashing  of a  stemmed array  (from a key). */
                                       /*names of the 9 regular polygons*/
values='triangle quadrilateral pentagon hexagon heptagon octagon nonagon decagon dodecagon'
keys  ='thuhree  vour          phive    sicks   zeaven   ate     nein    den     duzun'

/*superflous blanks added to humorous keys just 'cause it looks prettier*/
call hash values,keys                  /*hash the keys to the values.   */
parse arg query .                      /*what was specified on cmd line.*/
if query==''  then exit                /*nothing, then let's leave Dodge*/
pad=left('',30)                        /*used for padding the display.  */
say 'key:' query  pad  "value:"  hash.query    /*show & tell some stuff.*/
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────HASH subroutine─────────────────────*/
hash: procedure expose hash.;   parse arg v,k,hash.
            do j=1  until map='';        map=word(k,j)
                                    hash.map=word(v,j)
            end   /*j*/
return

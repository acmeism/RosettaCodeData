/*REXX program demonstrates  hashing  of a  stemmed array  (from a key or multiple keys)*/
key.=                                            /*names of the nine regular polygons.  */
vals= 'triangle quadrilateral pentagon hexagon heptagon octagon nonagon decagon dodecagon'
key.1='thuhree  vour          phive    sicks   zeaven   ate     nein    den     duzun'
key.2='three    four          five     six     seven    eight   nine    ten     twelve'
key.3='3        4             5        6       7        8       9       10      12'
key.4='III      IV            V        VI      VII      VIII    IX      X       XII'
key.5='iii      iv            v        vi      vii      viii    ix      x       xii'
hash.='───(not defined)───'                      /* [↑]  blanks added to humorous keys  */
                                                 /*      just because it looks prettier.*/
    do k=1  while key.k\==''
    call hash vals,key.k                         /*hash the   keys   to the   values.   */
    end   /*k*/

parse arg query .                                /*obtain what was specified on the C.L.*/
if query==''  then exit                          /*Nothing?  Then leave Dodge City.     */
say 'key:'  left(query,40)  "value:"  hash.query /*display some stuff to the terminal.  */
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
hash: parse arg @val,@key
                do j=1  for words(@key);          map= word(@key, j)
                                             hash.map= word(@val, j)
                end   /*j*/
      return

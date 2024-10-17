/*REXX program sorts an array of composite structures                 */
/* (which has two classes of data).                                   */
x.=0                           /*number elements in structure (so far)*/
Call add 'tan'   , 0           /*tan    peanut M&M's are  0%  of total*/
Call add 'orange',10           /*orange    "    "     "  10%   "   "  */
Call add 'yellow',20           /*yellow    "    "     "  20%   "   "  */
Call add 'green' ,20           /*green     "    "     "  20%   "   "  */
Call add 'red'   ,20           /*red       "    "     "  20%   "   "  */
Call add 'brown' ,30           /*brown     "    "     "  30%   "   "  */
Call show 'before sort'
Say copies('¦', 70)
Call xSort
call show ' after sort'
Exit                           /*stick a fork in it, we're all done.  */
/*--------------------------------------------------------------------*/
add: Procedure Expose x.
  z=x.0+1                      /* bump the number of structure entry  */
  x.z.color=arg(1)
  x.z.pc=arg(2)                /* construct an entry of the structure */
  x.0=z
  Return
/*--------------------------------------------------------------------*/
show: Procedure Expose x.
  Do i=1 To x.0
    /* display  what     name               value.                    */
    Say right(arg(1),30) right(x.i.color,9) right(x.i.pc,4)'%'
    End
  Return
/*--------------------------------------------------------------------*/
xsort: Procedure Expose x.
  h=x.0
  Do While h>1
    h=h%2
    Do i=1 For x.0-h
      j=i
      k=h+i
      Do While x.k.color<x.j.color
        _=x.j.color                 /* swap elements.                 */
        x.j.color=x.k.color
        x.k.color=_
        _=x.j.pc
        x.j.pc=x.k.pc
        x.k.pc=_
        If h>=j Then
          Leave
        j=j-h
        k=k-h
        End
      End
    End
  Return

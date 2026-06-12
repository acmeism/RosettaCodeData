/* REXX Polynomial Division                */
/* extended to support order of divisor >1 */
call set_dd '1 0 0 0 -1'
Call set_dr '1 1 1 1'
Call set_dd '1 -12 0 -42'
Call set_dr '1 -3'
q.0=0
Say list_dd '/' list_dr
do While dd.0>=dr.0
  q=dd.1/dr.1
  Do j=1 To dr.0
    dd.j=dd.j-q*dr.j
    End
  Call set_q q
  Call shift_dd
  End
say 'Quotient:' mk_list_q() 'Remainder:' mk_list_dd()
Exit

set_dd:
Parse Arg list
list_dd='['
Do i=1 To words(list)
  dd.i=word(list,i)
  list_dd=list_dd||dd.i','
  End
dd.0=i-1
list_dd=left(list_dd,length(list_dd)-1)']'
Return

set_dr:
Parse Arg list
list_dr='['
Do i=1 To words(list)
  dr.i=word(list,i)
  list_dr=list_dr||dr.i','
  End
dr.0=i-1
list_dr=left(list_dr,length(list_dr)-1)']'
Return

set_q:
z=q.0+1
q.z=arg(1)
q.0=z
Return

shift_dd:
Do i=2 To dd.0
  ia=i-1
  dd.ia=dd.i
  End
dd.0=dd.0-1
Return

mk_list_q:
list='['q.1''
Do i=2 To q.0
  list=list','q.i
  End
Return list']'

mk_list_dd:
list='['dd.1''
Do i=2 To dd.0
  list=list','dd.i
  End
Return list']'


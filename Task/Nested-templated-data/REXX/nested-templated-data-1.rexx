/* REXX */
tok.=''
Do i=0 To 6
  tok.i="'Payload#"i"'"
  End
t1='[[[1,2],[3,4,1],5]]'
t2='[[[1,6],[3,4,7,0],5]]'
Call transform t1
Call transform t2
Exit

transform:
Parse Arg t 1 tt
/* http://rosettacode.org/wiki/Nested_templated_data */
/*
[[['Payload#1', 'Payload#2'],
  ['Payload#3', 'Payload#4', 'Payload#1'],
  'Payload#5']]
*/
lvl=0
n.=0
o=''
w=''
used.=0
Do While t<>''
  Parse Var t c +1 1 c3 +3 1 c2 +2
  u=' '
  v=' '
  Select
    When c3='],[' Then Do
      o=o'  '
      w=w'  '
      t=substr(t,3)
      End
    When c2='],' Then Do
      o=o' '
      w=w' '
      t=substr(t,2)
      lvl=lvl-1
      End
    When c='[' Then
      lvl=lvl+1
    When c=']' Then
      lvl=lvl-1
    When c=',' Then
      Nop
    Otherwise Do
      u=lvl
      v=c
      End
    End
  t=substr(t,2)
  o=o||u
  w=w||v
  End
Say 'Template' tt
Do i=1 By 1 While w<>''
  If i=1 Then Do
    w=substr(w,4)
    p=pos('  ',w)
    Call o '[[['cont(left(w,p-1))'],'
    w=substr(w,p)
    End
  Else Do
    If left(w,3)='' Then Do
      w=substr(w,4)
      p=pos('  ',w)
      Call o '  ['cont(left(w,p-1))'],'
      w=substr(w,p)
      End
    Else Do
      w=substr(w,3)
      p=pos('  ',w)
      Call o '  'cont(left(w,p-1))']]'
      w=substr(w,p)
      End
    End
  End
Do i=0 To 6
  If used.i=0 Then Say 'Payload' i 'not used'
  End
Call o ' '
Return

o: Say arg(1)
   Return

cont: Procedure Expose tok. used.
  Parse Arg list
  res=''
  Do while list>''
    Parse Var list i list
    res= res tok(i)','
    End
  res=strip(res)
  res=strip(res,'T',',')
  Return res

tok: Procedure Expose tok. used.
Parse Arg i
If tok.i<>'' Then Do
  used.i=1
  Return tok.i
  End
Else
  Return "'Payload#" i "not defined'"

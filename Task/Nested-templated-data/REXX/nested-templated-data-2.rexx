/* REXX */
tok.=''
Do i=0 To 6
  tok.i="'Payload#"i"'"
  End
t1='[[[1,2],[ 3,4,1],5]]'
t2='1[[[1,6]],[[3,4[7] 0],5]3]9 [8] 9'
Call transform t1
Call transform t2
Exit

transform:
Parse Arg t 1 tt
t=space(t,0)
lvl=0
t.=0
used.=0
undefined=''
Do While t<>''
  Parse Var t c +1 t
  Select
    When c='[' Then
      lvl=lvl+1
    When c=']' Then
      lvl=lvl-1
    When c=',' Then
      Nop
    Otherwise Do
      t=c||t
      p1=pos(']',t)
      p2=pos('[',t)
      Select
        When p2=0 Then p=p1
        When p1=0 Then p=p2
        Otherwise p=min(p1,p2)
        End
      If p=0 Then Do
        Call mem lvl': >'t'<'
        t=''
        End
      Else Do
        Call mem lvl': >'left(t,p-1)'<'
        t=substr(t,p)
        End
      End
    End
  End
Call show
Return

mem:
z=t.0+1
t.z=arg(1)
t.0=z
Return

show:
Say tt
Say 'lvl Element'
Do i=1 To t.0
  Parse Var t.i lvl ':' '>' cont '<'
  ol=right(lvl,3) copies(' ',lvl*3)cont(cont)
  Say ol
  End
Do i=0 To 6
  If used.i=0 Then Say 'Payload' i 'not used'
  End
Do While undefined>''
  Parse Var undefined i undefined
  Say 'Payload' i 'is not defined'
  End
Call o ' '
Return

cont: Procedure Expose tok. used. undefined
  Parse Arg list
  list=translate(list,' ',',')
  res=''
  Do while list>''
    Parse Var list i list
    res= res tok(i)','
    End
  res=strip(res)
  res=strip(res,'T',',')
  Return res

tok: Procedure Expose tok. used. undefined
Parse Arg i
If tok.i<>'' Then Do
  used.i=1
  Return tok.i
  End
Else Do
  If wordpos(i,undefined)=0 Then
    undefined=undefined i
  Return "'Payload#"i "not defined'"
  End

o: Say arg(1)
   Return

/* REXX ***************************************************************
* extend in.csv to add a column containing the sum of the lines' elems
* 21.06.2013 Walter Pachl
**********************************************************************/
csv='in.csv'
Do i=1 By 1 While lines(csv)>0
  l=linein(csv)
  If i=1 Then
    l.i=l',SUM'
  Else Do
    ol=l
    sum=0
    Do While l<>''
      Parse Var l e ',' l
      sum=sum+e
      End
    l.i=ol','sum
    End
  End
Call lineout csv
'erase' csv
Do i=1 To i-1
  Call lineout csv,l.i
  End

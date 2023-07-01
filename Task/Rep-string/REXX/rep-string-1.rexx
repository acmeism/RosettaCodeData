/* REXX ***************************************************************
* 11.05.2013 Walter Pachl
* 14.05.2013 Walter Pachl extend to show additional rep-strings
**********************************************************************/
Call repstring '1001110011'
Call repstring '1110111011'
Call repstring '0010010010'
Call repstring '1010101010'
Call repstring '1111111111'
Call repstring '0100101101'
Call repstring '0100100'
Call repstring '101'
Call repstring '11'
Call repstring '00'
Call repstring '1'
Exit

repstring:
Parse Arg s
sq=''''s''''
n=length(s)
Do l=length(s)%2 to 1 By -1
  If substr(s,l+1,l)=left(s,l) Then Leave
  End
If l>0 Then Do
  rep_str=left(s,l)
  Do i=1 By 1
    If substr(s,i*l+1,l)<>rep_str Then
      Leave
    End
  If left(copies(rep_str,n),length(s))=s Then Do
    Call show_rep rep_str              /* show result                */
    Do i=length(rep_str)-1 To 1 By -1  /* look for shorter rep_str-s */
      rep_str=left(s,i)
      If left(copies(rep_str,n),length(s))=s Then
        Call show_rep rep_str
      End
    End
  Else
    Call show_norep
  End
Else
  Call show_norep
Return

show_rep:
  Parse Arg rs
  Say right(sq,12) 'has a repetition length of' length(rs) 'i.e.' ''''rs''''
  Return
show_norep:
  Say right(sq,12) 'is not a repeated string'
  Return

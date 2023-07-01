/* REXX ***************************************************************
* 20.08.2013 Walter Pachl  "my way"
* 23.08.2013 Walter Pachl changed to use lastpos bif
**********************************************************************/
Parse Arg w
oid=w'.xxx'; 'erase' oid
Call o left(copies('123456789.',20),w)
s='She should have died hereafter;' ,
  'There would have been a time for such a word.' ,
  'Tomorrow, and tomorrow, and tomorrow, and so on'
Call ow s
Exit
ow:
  Parse Arg s
  s=s' '
  Do While length(s)>w
    i=lastpos(' ',s,w+1) /* instead of loop */
    If i=0 Then
      p=pos(' ',s)
    Else
      p=i
    Call o left(s,p)
    s=substr(s,p+1)
    End
  If s>'' Then
    Call o s
  Return
o:Return lineout(oid,arg(1))

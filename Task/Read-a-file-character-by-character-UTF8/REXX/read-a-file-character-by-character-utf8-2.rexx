/* REXX ---------------------------------------------------------------
* 29.12.2013 Walter Pachl
* read one utf8 character at a time
* see http://de.wikipedia.org/wiki/UTF-8#Kodierung
*--------------------------------------------------------------------*/
oid='utf8.txt';'erase' oid /* first create file containing utf8 chars*/
Call charout oid,'79'x
Call charout oid,'C3A4'x
Call charout oid,'C2AE'x
Call charout oid,'E282AC'x
Call charout oid,'F09D849E'x
Call lineout oid
fid='utf8.txt'             /* then read it and show the contents     */
Do Until c8='EOF'
  c8=get_utf8char(fid)
  Say left(c8,4) c2x(c8)
  End
Exit

get_utf8char: Procedure
  Parse Arg f
  If chars(f)=0 Then
    Return 'EOF'
  c=charin(f)
  b=c2b(c)
  If left(b,1)=0 Then
    Nop
  Else Do
    p=pos('0',b)
    Do i=1 To p-2
      If chars(f)=0 Then Do
        Say 'illegal contents in file' f
        Leave
        End
      c=c||charin(f)
      End
    End
  Return c

c2b: Return x2b(c2x(arg(1)))

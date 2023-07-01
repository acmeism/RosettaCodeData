/* REXX ---------------------------------------------------------------
* 14.12.2013 Walter Pachl  a short solution
* 16.12.2013 fix duplicate element problem in input
* 16.12.2013 added duplicate to t.
* Handles only sets the elements of which do not contain blanks
*--------------------------------------------------------------------*/
s='John Bob Mary Serena'
t='Jim Mary John Bob Jim '
Say difference(s,t)
Exit
difference:
Parse Arg a,b
res=''
Do i=1 To words(a)
  If wordpos(word(a,i),b)=0 Then
    Call out word(a,i)
  End
Do i=1 To words(b)
  If wordpos(word(b,i),a)=0 Then
    Call out word(b,i)
  End
Return strip(res)
out: parse Arg e
If wordpos(e,res)=0 Then res=res e
Return

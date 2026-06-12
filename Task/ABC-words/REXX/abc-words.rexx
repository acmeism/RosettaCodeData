/*REXX program finds all ABC words adhering to the specified letters */
parse upper arg letters
iFID='unixdict.txt'
Parse Upper Arg letters
If letters='' Then letters='ABC'        /*Not specified?  Then use the default.*/
Do i=1 to length(letters)
  c.i=substr(letters,i,1)
  End
say letters 'words are:'
num = 0
Do while lines(ifid)>0
  l=linein(ifid)
  p.1=pos(c.1,translate(l))
  If p.1>0 Then Do
    Do i=2 To length(letters)
      ia=i-1
      p.i=pos(c.i,translate(l))
      If p.i<=p.ia Then leave i
      End
    If i>length(letters) Then
      Say format(num,2) L
    End
  End

var.='something' /* sets all possible compound variables of stem var. */
x='3 '
var.x.x.4='something else'
Do i=1 To 5
  a=left(i,2)
  Say i var.a.a.4 "(tail is '"a||'.'||a||'.'||'4'"')"
  End

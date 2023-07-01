list='aa bb cc dd'
sep=', '
Do i=1 By 1 While list<>''
  If i>1 Then Call charout ,sep
  Parse Var list item list
  Call charout ,item
  End

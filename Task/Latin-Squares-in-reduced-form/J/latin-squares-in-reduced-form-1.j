redlat=: {{
  perms=: (A.&i.~ !)~ y
  sqs=. i.1 1,y
  for_j.}.i.y do.
    p=. (j={."1 perms)#perms
    sel=.-.+./"1 p +./@:="1/"2 sqs
    sqs=.(#~ 1-0*/ .="1{:"2),/sqs,"2 1 sel#"2 p
  end.
}}

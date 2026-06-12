bigsteady=: {{
 Y=. 1+s=.0x
 whilst. Y < y do.
  s=. (#~ issteady) ,(Y*i.10)+/s
  Y=. Y*10
 end.
 s #~ y>s
}}

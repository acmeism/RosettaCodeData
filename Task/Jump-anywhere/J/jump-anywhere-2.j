H=: verb define
  smoutput 'a'
  label_b.
  smoutput 'c'
  goto_f.
  label_d.
  smoutput 'e' return.
  label_f.
  smoutput 'g'
  goto_d.
  smoutput 'h'
)

   H''
a
c
g
e

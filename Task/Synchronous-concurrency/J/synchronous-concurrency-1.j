input=: 1 :0
  nlines=: 0
  u;._2@fread 'input.txt'
  smoutput nlines
)

output=: 3 :0
  nlines=: nlines+1
  smoutput y
)

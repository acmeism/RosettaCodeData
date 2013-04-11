output=: verb define
  buffer=: buffer,y
)

loopy=: verb define
  buffer=: ''
  for_n. 1+i.10 do.
    output ":n
    if. n<10 do.
      output ', '
    end.
  end.
  smoutput buffer
)

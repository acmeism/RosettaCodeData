coclass 'activeobject'
require'dates'

create=:setinput NB. constructor

T=:3 :0
  if. nc<'T0' do. T0=:tsrep 6!:0'' end.
  0.001*(tsrep 6!:0'')-T0
)

F=:G=:0:
Zero=:0

setinput=:3 :0
  zero=. getoutput''
  '`F ignore'=: y,_:`''
  G=: F f.d._1
  Zero=: zero-G T ''
  getoutput''
)

getoutput=:3 :0
  Zero+G T''
)

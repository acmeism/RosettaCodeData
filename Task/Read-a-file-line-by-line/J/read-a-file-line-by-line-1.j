cocurrent 'linereader'

  NB. configuration parameter
  blocksize=: 400000

  NB. implementation
  offset=: 0
  position=: 0
  buffer=: ''
  lines=: ''

  create=: monad define
    name=: boxxopen y
    size=: 1!:4 name
    blocks=: 2 <@(-~/\)\ ~. size <. blocksize * i. 1 + >. size % blocksize
  )

  readblocks=: monad define
     if. 0=#blocks do. return. end.
     if. 1<#lines do. return. end.
     whilst. -.LF e.chars do.
       buffer=: buffer,chars=. 1!:11 name,{.blocks
       blocks=: }.blocks
       lines=: <;._2 buffer,LF
     end.
     buffer=: _1{::lines
  )

  next=: monad define
    if. (#blocks)*.2>#lines do. readblocks'' end.
    r=. 0{::lines
    lines=: }.lines
    r
  )

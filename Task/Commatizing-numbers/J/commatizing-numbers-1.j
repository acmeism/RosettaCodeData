require'regex'
commatize=:3 :0"1 L:1 0
  (i.0) commatize y
:
NB. deal with all those rules about options
  opts=. boxopen x
  char=. (#~ ' '&=@{.@(0&#)@>) opts
  num=. ;opts-.char
  delim=. 0 {:: char,<','
  'begin period'=. _1 0+2{.num,(#num)}.1 3
NB. initialize
  prefix=. begin {.y
  text=. begin }. y
NB. process
  'start len'=. ,'[1-9][0-9]*' rxmatch text
  if.0=len do. y return. end.
  number=. (start,:len) [;.0 text
  numb=. (>:period|<:#number){.number
  fixed=. numb,;delim&,each (-period)<\ (#numb)}.number
  prefix,(start{.text),fixed,(start+len)}.text
)

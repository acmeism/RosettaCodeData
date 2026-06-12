b2b=:2 :0
  NB. string to rational number
  exp=. (1x+y i.'.')-#y
  mant=. n#.x:0"."0 y-.'.'
  number=. mant*n^exp*'.' e. y
  NB. rational number to string
  exp=. _99
  mant=. <.1r2+number*m^x:-exp
  s=. exp&(}.,'.',{.) (":m#.inv mant)-.' '
  ((exp-1)>.-+/*/\|.s e.'.0') }. s
)

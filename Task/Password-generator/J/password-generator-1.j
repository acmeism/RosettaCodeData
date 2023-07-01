thru=: <. + i.@(+*)@-~
chr=: a.&i.

lower=: 'a' thru&.chr 'z'
upper=: 'A' thru&.chr 'Z'
digit=: '0' thru&.chr '9'
other=: ('!' thru&.chr '~')-.lower,upper,digit,'`\'
all=: lower,upper,digit,other

pwgen =:verb define"0 :: pwhelp
  NB. pick one of each, remainder from all, then shuffle
  (?~y) { (?@# { ])every lower;upper;digit;other;(y-4)#<all
:
  pwgen x#y
)

pwhelp =:echo bind (noun define)
  [x] pwgen y - generates passwords of length y
  optional x says how many to generate (if you want more than 1)

  y must be at least 4 because
  passwords must contain four different kinds of characters.
)

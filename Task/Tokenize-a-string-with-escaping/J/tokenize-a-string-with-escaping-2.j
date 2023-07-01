tokenize2=: tokenize=:3 :0
  '^|' tokenize2 y  NB. task default escape and separator
:
  'ESC SEP'=. x
  E=. 18 b./\.&.|.ESC=y NB. escape positions
  S=. (SEP=y)>_1}.0,E NB. separator positions
  K=. -.E+.S NB. keep positions
  T=. (#y){. 1,}.S NB. token beginnings
  (T<;.1 K)#&.>T<;.1 y
)

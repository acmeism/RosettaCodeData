chget=: {{(0;1;1;1) {:: y}}

chset=: {{
  'A B'=.;y
  'C D'=.B
  'E F'=.D
  <A;<C;<E;<<.x
}}

ch0=: {{
  if.0=#y do.y=.;:'>:' end. NB. replace empty gerund with increment
  0 chset y`:6^:2`''
}}

apply=: `:6

chNext=: {{(1+chget y) chset y}}

chAdd=: {{(x +&chget y) chset y}}
chSub=: {{(x -&chget y) chset y}}
chMul=: {{(x *&chget y) chset y}}
chExp=: {{(x ^&chget y) chset y}}
int2ch=: {{y chset ch0 ''}}
ch2int=: chget

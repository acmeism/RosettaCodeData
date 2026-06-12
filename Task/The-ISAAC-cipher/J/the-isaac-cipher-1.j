NB. bitwise logic on 32 bit unsigned values
ub4=: (#.33{.1)&|
xor=: ub4@(2b10110 b.)
shl=: ub4@(33 b.~)
add=: ub4@+

isaac=: {{
  cc=: cc add 1
  bb=: bb add cc
  for_i.i.256 do.
    aa=. aa xor aa shl 13 _6 2 _16{~4|i
     X=.  i{mm
    aa=.                 aa add        mm{~ 256| i+128
     y=.                 aa add bb add mm{~ 256| X shl _2
    randrsl=: randrsl i}~  bb=.  X add mm{~ 256| y shl _10
  end.
  randcnt=: 0
}}

mix=: {{
  b=: b add c [ d=: d add a=: a xor b shl  11
  c=: c add d [ e=: e add b=: b xor c shl  _2
  d=: d add e [ f=: f add c=: c xor d shl   8
  e=: e add f [ g=: g add d=: d xor e shl _16
  f=: f add g [ h=: h add e=: e xor f shl  10
  g=: g add h [ a=: a add f=: f xor g shl  _4
  h=: h add a [ b=: b add g=: g xor h shl   8
  a=: a add b [ c=: c add h=: h xor a shl  _9
}}

randinit=: {{
  aa=: bb=: cc=: 0
  a=: b=: c=: d=: e=: f=: g=: h=: 16b9e3779b9
  mix^:4''
  if. y do.
    for_i. _8]\i.256 do.
      mix 'a b c d e f g h'=: (a,b,c,d,e,f,g,h) add i{randrsl
      mm=: mm i}~ a,b,c,d,e,f,g,h
    end.
    for_i.  _8]\i.256 do.
      mix 'a b c d e f g h'=: (a,b,c,d,e,f,g,h) add i{mm
      mm=: mm i}~ a,b,c,d,e,f,g,h
    end.
  else.
    for_i.  _8]\i.256 do.
      mix ''
      mm=: mm i}~ a,b,c,d,e,f,g,h
    end.
  end.
  isaac''
}}

iRandom=: {{
  r=. randcnt { randrsl
  if. 255 < randcnt=: randcnt+1 do. isaac'' end.
  r
}}

iRandA=: {{ 7 u: 32+95|iRandom^:(1+i.y)'' }}

iSeed=: {{ NB. y: seed, x: flag
  0 iSeed y
:
  mm=: 256#0
  randrsl=: 256{.3 u: y
  randinit x
}}

vernam=: {{ y xor&.(3&u:) iRandA #y }}

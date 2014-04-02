text2bits=: (8#2) ,@:#: a. i. ]
words2bits=: ,@:((32#2)&#:)

pad=: _32 #.\ (, 1,(0#~512 | [: - 65 + #),(64#2)#:#)
lim32=: 2^32
rot32=: (] lim32&|@* 2 ^ [) + ] <.@% 2 ^ 32- [
and=: 17 b.
notimplies=: 18 b.
xor=: 22 b.
or=: 23 b.

f=:4 :0
  'B C D'=: y
  if. x < 20 do.
    (B and C) or D notimplies B
  elseif. x < 40 do.
    B xor C xor D
  elseif. x < 60 do.
    (B and C) or (B and D) or C and D
  elseif. x < 80 do.
    B xor C xor D
  end.
)

K=: 16b5a827999 16b6ed9eba1 16b8f1bbcdc 16bca62c1d6 {~ <.@%&20

process=:3 :0
  H=. 16b67452301 16befcdab89 16b98badcfe 16b10325476 16bc3d2e1f0
  W=. (, [: , 1 rot32 _3 _8 _14 _16 xor/@:{ ])^:64 y
  'A B C D E'=. H
  for_t. i.80 do.
    TEMP=. lim32|(5 rot32 A) + (t f B,C,D) + E + (W{~t) + K t
    E=. D
    D=. C
    C=. 30 rot32 B
    B=. A
    A=. TEMP
  end.
  ,lim32|H + A,B,C,D,E
)

sha1=: _16 process\ pad

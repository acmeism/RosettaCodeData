pad=: ,1,(0#~512 | [: - 65 + #),(64#2)#:#

f=:4 :0
  'B C D'=: _32 ]\ y
  if. x < 20 do.
    (B*C)+.D>B
  elseif. x < 40 do.
    B~:C~:D
  elseif. x < 60 do.
    (B*C)+.(B*D)+.C*D
  elseif. x < 80 do.
    B~:C~:D
  end.
)

K=: ((32#2) #: 16b5a827999 16b6ed9eba1 16b8f1bbcdc 16bca62c1d6) {~ <.@%&20

plus=:+&.((32#2)&#.)

H=: #: 16b67452301 16befcdab89 16b98badcfe 16b10325476 16bc3d2e1f0

process=:4 :0
  W=. (, [: , 1 |."#. _3 _8 _14 _16 ~:/@:{ ])^:64 x ]\~ _32
  'A B C D E'=. y=._32[\,y
  for_t. i.80 do.
    TEMP=. (5|.A) plus (t f B,C,D) plus E plus (W{~t) plus K t
    E=. D
    D=. C
    C=. 30 |. B
    B=. A
    A=. TEMP
  end.
  ,y plus A,B,C,D,:E
)

sha1=: [:> [: process&.>/ (<H) (,~ |.) _512<\ pad

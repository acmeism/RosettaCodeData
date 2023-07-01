NB. implement inverse Burrows—Wheeler transform sequence method

repeat_alphabet=:  [: , [: i.&> (^ <:) # [
assert 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 -: 2 repeat_alphabet 4

de_bruijn=: ({~ ([: ; [: C. /:^:2))@:repeat_alphabet     NB. K de_bruijn N

pins=: #&10 #: [: i. 10&^   NB. pins y  generates all y digit PINs
groups=: [ ]\ ] , ({.~ <:)~    NB. length x infixes of sequence y cyclically extended by x-1
verify_PINs=: (/:~@:groups -: pins@:[)  NB. LENGTH verify_PINs SEQUENCE

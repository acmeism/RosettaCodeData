NB. stops setcode alphabet
NB. creates verbs encode and decode which change between unencoded text and lists of encoded numbers
   setcode=: 3 :0
2 6 setcode y
:
alphabet=: y, ,":"0 i.10
stops=. x
alphkeys=. (a: , ,&.> x) ([ -.~ [: , ,&.>/) i.10
esckey=. >(alphabet i. '/'){alphkeys
numkeys=. esckey&,&.> i.10
keys=. alphkeys,numkeys

encode=: ([: ; keys {~ alphabet&i.) :. decode
break=. </.~ i.@# - _1|. ([: >/\.&.|. e.&stops) + _1|.2*esckey&E.
decode=: (alphabet {~ keys i. break f.) :. encode
i.0 0
)

nodes=: 10 10 #: i. 100
nodeA=: 1 1
nodeB=: 6 7

NB. verb to pair up coordinates along a specific offset
conn =: [: (#~ e.~/@|:~&0 2) ([ ,: +)"1

ref =: ~. nodeA,nodes-.nodeB                    NB. all nodes, with A first and B omitted
wiring=: /:~ ref i. ,/ nodes conn"2 1 (,-)=i.2  NB. connected pairs (indices into ref)
Yii=: (* =@i.@#) #/.~ {."1 wiring               NB. diagonal of Y represents connections to B
Yij=: -1:`(<"1@[)`]}&(+/~ 0*i.1+#ref) wiring    NB. off diagonal of Y represents wiring
Y=: _1 _1 }. Yii+Yij

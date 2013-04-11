nodes=: 10 10 #: i. 100
nodeA=: 1 1
nodeB=: 6 7

conn =: [: (#~ e.~/@|:~&0 2) ([ ,: +)"1
ref =: ~. nodeA,nodes-.nodeB
wiring=: /:~ ref i. ,/ nodes conn"2 1 (,-)=i.2
Yii=: _1 _1 }. (* =@i.@#) #/.~ {."1 wiring
Yij=: - _1 _1 }. 1:`(<"1@[)`]}&(+/~ 0*i.1+#ref) wiring
Y=: Yii+Yij

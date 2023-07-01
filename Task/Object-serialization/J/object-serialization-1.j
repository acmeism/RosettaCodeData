lin_z_=:5!:5
serializeObject=:3 :0
  p=. copath y
  d=. ;LF;"1(,'=:';lin__y)"0 nl__y i.4
  '(',(5!:5<'p'),')(copath[cocurrent@])cocreate ''''',,d,LF
)

deserializeObject=:3 :0
  o=.conl 1
  0!:100 y
  (conl 1)-.o
)

coclass'room'
  create=:3 :'size=:y'
  print=:3 :'''room size '',":size'

coclass'kitchen'
  coinsert'room'
  print=:3 :'''kitchen size '',":size'

coclass'kitchenWithSink'
  coinsert'kitchen'
  print=:3 :'''kitchen with sink size '',":size'

cocurrent'base'

R=:'small' conew 'room'
K=:'medium' conew 'kitchen'
S=:'large' conew 'kitchenWithSink'
print__R''
print__K''
print__S''


(;<@serializeObject"0 R,K,S) 1!:2 <'objects.dat'

'r1 k1 s1'=: <"0 deserializeObject 1!:1<'objects.dat'
print__r1''
print__k1''
print__s1''

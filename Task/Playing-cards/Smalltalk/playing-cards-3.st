st> myDeck := Deck of: Card
a Deck
st> myDeck displayNl
2d 3d 4d 5d 6d 7d 8d 9d Td Jd Qd Kd Ad 2s 3s 4s 5s 6s 7s 8s 9s Ts Js Qs Ks As 2h 3h 4h 5h 6h 7h 8h 9h Th Jh Qh Kh Ah 2c 3c 4c 5c 6c 7c 8c 9c Tc Jc Qc Kc Ac
st> myDeck shuffle
a Deck
st> myDeck displayNl
6c 7d Ac 4c 9s 2s Tc 9c Jh 3h Kh 7h 3s 5s 3d Kd Jc Qs As Qd 3c Kc Qh 2d 9h 4h 8c 7s Ah 9d Js 6h 8s 8h 5c 2c 4s 8d 5d Ts 4d Qc Td 7c 2h 5h 6s 6d Th Ks Jd Ad
st> myHand := OrderedCollection new
OrderedCollection ()
st> 5 timesRepeat: [myHand add: myDeck deal]
5
st> myHand
OrderedCollection ('Ad' 'Jd' 'Ks' 'Th' '6d' )

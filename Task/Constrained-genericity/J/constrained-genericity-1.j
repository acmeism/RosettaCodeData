coclass'Connoisseur'
isEdible=:3 :0
  0<nc<'eat__y'
)

coclass'FoodBox'
create=:3 :0
  assert isEdible_Connoisseur_ type=:y
  collection=: 0#y
)
add=:3 :0"0
  'inedible' assert type e. copath y
  collection=: collection, y
)

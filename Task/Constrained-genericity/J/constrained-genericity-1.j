coclass'Connoisseur'
isEdible=:3 :0
  0<nc<'eat__y'
)

coclass'FoodBox'
create=:3 :0
  collection=: 0#y
)
add=:3 :0"0
  'inedible' assert isEdible_Connoisseur_ y
  collection=: collection, y
  EMPTY
)

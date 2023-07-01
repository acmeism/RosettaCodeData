build0=:3 :0
  data=: y
)

distance=: +/&.:*:@:-"1

nearest0=:3 :0
  nearest=. data {~ (i. <./) |data distance y
  (nearest distance y);(#data);nearest
)

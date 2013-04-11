task=: verb define
  assert. y -: 0 0 + , y       NB. error except when 2 dimensions are specified
  INIT=. 0                     NB. array will be populated with this value
  NEW=. 1                      NB. we will later update one location with this value
  ARRAY=. y $ INIT             NB. here, we create our 2-dimensional array
  INDEX=. < ? $ ARRAY          NB. pick an arbitrary location within our array
  ARRAY=. NEW INDEX} ARRAY     NB. use our new value at that location
  INDEX { ARRAY                NB. and return the value from that location
)

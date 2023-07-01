NB. y is words in boxes
abbreviation_length =: monad define
 N =. # y
 for_i. i. >: >./ #&> y do.
  NB. if the length of the set of length i prefixes matches the length of the row
  if. N -: # ~. i ({. &>) y do.
   i return.
  end.
 end.
)

NB. use: auto_abbreviate DAY_NAMES
auto_abbreviate =: 3 :0
 y =. y -. CR
 lines =. [;._2 y
 a =. <@([: <;._2 ,&' ');._2 y
 L =. abbreviation_length&> a
 ((' ',~":)&> L) ,"1 lines
)

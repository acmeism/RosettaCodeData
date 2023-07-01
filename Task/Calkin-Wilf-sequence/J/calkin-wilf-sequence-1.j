cw_next_term=: [: % +:@<. + -.

ccf =: compute_continued_fraction=: 3 :0
 if. 0 -: y do.
  , 0
 else.
  result=. i. 0
  remainder=. % y
  whilst. remainder do.
   remainder=. % remainder
   integer_part=. <. remainder
   remainder=. remainder - integer_part
   result=. result , integer_part
  end.
 end.
)

molcf =: make_odd_length_continued_fraction=: (}: , 1 ,~ <:@{:)^:(0 -: 2 | #)

NB. base 2  @  reverse  @   the cf's representation copies of 1 0 1 0 ...
index_cw_term=: #.@|.@(# 1 0 $~ #)@molcf@ccf

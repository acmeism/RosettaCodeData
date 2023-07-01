load 'trig stats'
RHS=: *:                               NB. right-hand-side of Cosine Law
LHS=: +/@:*:@] - cos@rfd@[ * 2 * */@]  NB. Left-hand-side of Cosine Law

solve=: 4 :0
  adjsides=. >: 2 combrep y
  oppside=. >: i. y
  idx=. (RHS oppside) i. x LHS"1 adjsides
  adjsides ((#~ idx ~: #) ,. ({~ idx -. #)@]) oppside
)

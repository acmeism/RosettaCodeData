simulate=:3 :0
  1 2 3 simulate y
:
  pick=. {~ ?@#
  scenario=. ((pick@-.,])pick,pick) bind x
  stayWin=. =/@}.
  switchWin=. pick@(x -. }:) = {:
  r=.(stayWin,switchWin)@scenario"0 i.y
  labels=. ];.2 'limit stay switch '
  smoutput labels,.":"0 y,+/r
)

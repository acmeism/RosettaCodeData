histogram=: <: @ (#/.~) @ (i.@#@[ , I.)

meanstddevP=: 3 :0
  NB. compute mean and std dev of y random numbers
  NB. picked from even distribution between 0 and 1
  NB. and display a normalized ascii histogram for this sample
  NB. note: uses population mean (0.5), not sample mean, for stddev
  NB.       given the equation specified for this task.
  h=.s=.t=. 0
  chunk=. 1e6
  bins=. (%~ 1 + i.) 10
  for. i. <.y%chunk do.
    data=. chunk ?@$ 0
    h=. h+ bins histogram data
    s=. s+ +/ data
    t=. t+ +/ *: data-0.5
  end.
  data=. (chunk|y) ?@$ 0
  h=. h+ bins histogram data
  s=. s+ +/ data
  t=. t+ +/ *: data - 0.5
  smoutput (<.300*h%y) #"0 '#'
  (s%y) , %:t%y
)

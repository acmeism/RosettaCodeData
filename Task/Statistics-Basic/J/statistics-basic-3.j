histogram=: <: @ (#/.~) @ (i.@#@[ , I.)

meanstddevP=:3 :0
  NB. compute mean and std dev of y random numbers
  NB. picked from even distribution between 0 and 1
  NB. and display a normalized ascii histogram for this sample
  NB. note: should use population mean, not sample mean, for stddev
  NB.       given the equation specified for this task.
  h=.s=.t=. 0
  buckets=. (%~1+i.)10
  for_n.i.<.y%1e6 do.
    data=. ?1e6#0
    h=.h+ buckets histogram data
    s=.s+ +/ data
    t=.t+ +/(data-0.5)^2
  end.
  data=. ?(1e6|y)#0
  h=.h+ buckets histogram data
  s=.s+ +/ data
  t=.t++/(data-0.5)^2
  smoutput (<.300*h%y)#"0'#'
  (s%y),%:t%y
)

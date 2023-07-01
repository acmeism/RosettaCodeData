fspuz2=:dyad define
  range=: x+i.1+y-x
  lo=. 3*x
  hi=. 2*y
  r=.i.0 0
  if. lo <: hi do.
    for_T.lo ([+[:i.1+-~) hi do.
      ab=: (,.T-])range
      abc=: ,/ab,"1 0/ range
      abcd=: (#~ T = +/@}."1) ,/abc,"1 0/ range
      abcde=: ,/abcd,"1 0/ range
      abcdef=: (#~ T = +/@(3}.])"1) ,/abcde ,"1 0/ range
      abcdefg=: (#~ T = +/@(5}.])"1) ,/abcdef,"1 0/ range
      r=.r,(#~ x<:<./"1)(#~ y>:>./"1)abcdefg
    end.
  end.
)

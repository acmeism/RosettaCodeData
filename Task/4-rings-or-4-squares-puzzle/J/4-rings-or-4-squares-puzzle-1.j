fspuz=:dyad define
  range=: x+i.1+y-x
  lo=. 6+3*x
  hi=. _3+2*y
  r=.i.0 0
  if. lo <: hi do.
    for_T.lo ([+[:i.1+-~) hi do.
      range2=: (#~ (T-{.range)>:]) range
      range3=: (#~ (T-+/2{.range)>:]) range
      ab=: (#~ ~:/"1) (,.T-])range2
      abc=: ;ab <@([ ,"1 0 -.~)"1/range3
      abcd=: (#~ T = +/@}."1) ;abc <@([ ,"1 0 -.~)"1/range3
      abcde=: ;abcd <@([ ,"1 0 -.~)"1/range3
      abcdef=: (#~ T = +/@(3}.])"1) ;abcde <@([ ,"1 0 -.~)"1/range3
      abcdefg=: (#~ T = +/@(5}.])"1) ;abcdef <@([ ,"1 0 -.~)"1/range2
      r=.r,(#~ x<:<./"1)(#~ y>:>./"1)abcdefg
    end.
  end.
)

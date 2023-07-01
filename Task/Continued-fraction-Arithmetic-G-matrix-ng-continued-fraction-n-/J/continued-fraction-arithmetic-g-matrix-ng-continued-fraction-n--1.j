ng4cf=: 4 : 0
  cf=. 1000{.!._ y
  ng=. x
  r=.i. ndx=.0
  while. +./0~:{:ng do.
    if.=/<.%/ng do.
      r=.r, t=.{.<.%/ng
      ng=. t (|.@] - ]*0,[) ng
    else.
      if. _=t=.ndx{cf do.
        ng=. ng+/ .*2 2$1 1 0 0
      else.
        ng=. ng+/ .*2 2$t,1 1 0
      end.
      if. (#cf)=ndx=. ndx+1 do. r return. end.
    end.
  end.
  r
)

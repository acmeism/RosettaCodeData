leg=: dyad define
  x (y&|)@^ (y-1)%2
)

tosh=:dyad define
  assert. 1=1 p: y [ 'y must be prime'
  assert. 1=x leg y [ 'x must be square mod y'
  pow=. y&|@^
  if. 1=m=. {.1 q: y-1 do.
    r=. x pow (y+1)%4
  else.
    z=. 1x while. 1>: z leg y do. z=.z+1 end.
    c=. z pow q=. (y-1)%2^m
    r=. x pow (q+1)%2
    t=. x pow q
    while. t~:1 do.
      n=. t
      i=. 0
      whilst. 1~:n do.
        n=. n pow 2
        i=. i+1
      end.
      r=. y|r*b=. c pow 2^m-i+1
      m=. i
      t=. y|t*c=. b pow 2
    end.
  end.
  y|(,-)r
)

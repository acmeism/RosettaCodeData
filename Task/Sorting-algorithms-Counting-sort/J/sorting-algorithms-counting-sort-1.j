csort =: monad define
  min =. <./y
  cnt =. 0 $~ 1+(>./y)-min
  for_a. y do.
    cnt =. cnt >:@{`[`]}~ a-min
  end.
  cnt # min+i.#cnt
)

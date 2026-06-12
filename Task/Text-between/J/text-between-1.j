textBetween=: dyad define
  text=. y
  'start end'=. x
  start=. ''"_^:('start'&-:) start
  end=. text"_^:('end'&-:) end
  end taketo start takeafter text
)

rls=: 3 : 0
  s=. ?~ y             NB. "deal" y unique integers from 0 to y
  for_ijk. i.<:y do.
    NB. deal a new row. subtract it from all previous rows
    NB. if you get a 0, some column has a matching integer, deal again
    whilst. 0 = */ */ s -"1 r do.
      r=. ?~ y
    end.
    s=. s ,,: r        NB. "laminate" successful row to the square
  end.
)

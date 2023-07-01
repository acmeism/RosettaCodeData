levdist =:4 :0
  'a b'=. (x;y) /: (#x),(#y)
  D=. >: iz =. i.#b
  for_j. a do.
    D=. <./\&.(-&iz) (>: D) <. (j ~: b) + |.!.j_index D
  end.
  {:D
)

[qsort
  [joinparts [p [*l1] [*l2] : [*l1 p *l2]] view].
  [split_on_first uncons [>] split].
  [small?]
    []
    [split_on_first [l1 l2 : [l1 qsort l2 qsort joinparts]] view i]
  ifte].

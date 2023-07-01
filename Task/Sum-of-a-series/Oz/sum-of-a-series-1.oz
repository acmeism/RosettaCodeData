declare
  fun {SumSeries S N}
     {FoldL {Map {List.number 1 N 1} S}
      Number.'+' 0.}
  end

  fun {S X}
     1. / {Int.toFloat X*X}
  end
in
  {Show {SumSeries S 1000}}

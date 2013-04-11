  fun {SumSeries S N}
     R = {NewCell 0.}
  in
     for I in 1..N do
        R := @R + {S I}
     end
     @R
  end

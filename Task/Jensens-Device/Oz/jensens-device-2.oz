declare
  fun {Sum Lo Hi F}
     {FoldL {Map {List.number Lo Hi 1} F} Number.'+' 0.0}
  end
in
  {Show {Sum 1 100 fun {$ I} 1.0/{Int.toFloat I} end}}

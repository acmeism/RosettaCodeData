local
  fun fmtNonZero (0, _, list) = list
    | fmtNonZero (n, s, list) = Int.toString n ^ " " ^ s :: list
  fun divModHead (_, []) = []
    | divModHead (d, head :: tail) = head div d :: head mod d :: tail
in
  fun compoundDuration seconds =
    let
      val digits = foldl divModHead [seconds] [60, 60, 24, 7]
      and units = ["wk", "d", "hr", "min", "sec"]
    in
      String.concatWith ", " (ListPair.foldr fmtNonZero [] (digits, units))
    end
end

val () = app (fn s => print (compoundDuration s ^ "\n")) [7259, 86400, 6000000]

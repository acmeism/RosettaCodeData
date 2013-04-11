(* 1.64393456668 *)
List.foldl op+ 0.0 (List.tabulate(1000, fn x => 1.0 / Math.pow(real(x + 1),2.0)))

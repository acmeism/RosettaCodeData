local
  val v = Vector.tabulate (10, fn 1 => "st" | 2 => "nd" | 3 => "rd" | _ => "th")
  fun getSuffix x =
    if 3 < x andalso x < 21 then "th" else Vector.sub (v, x mod 10)
in
  fun nth n =
    Int.toString n ^ getSuffix (n mod 100)
end

(* some test ouput *)
val () = (print o concat o List.tabulate)
  (26, fn i => String.concatWith "\t" (map nth [i, i + 250, i + 1000]) ^ "\n")

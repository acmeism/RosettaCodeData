let luhn s =
  let rec g r c = function
  | 0 -> r
  | i ->
      let d = c * ((int_of_char s.[i-1]) - 48) in
      g (r + (d/10) + (d mod 10)) (3-c) (i-1)
  in
  (g 0 1 (String.length s)) mod 10 = 0
;;

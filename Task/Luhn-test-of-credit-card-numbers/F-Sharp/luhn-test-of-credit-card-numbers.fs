let luhn (s:string) =
  let rec g r c = function
  | 0 -> r
  | i ->
      let d = ((int s.[i - 1]) - 48) <<< c
      g (r + if d < 10 then d else d - 9) (1 - c) (i - 1)
  (g 0 0 s.Length) % 10 = 0

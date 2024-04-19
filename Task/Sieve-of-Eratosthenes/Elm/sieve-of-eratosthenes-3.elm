primesArrayOdds : Int -> List Int
primesArrayOdds n =
  if n < 2 then [] else
  let
    sz = (n - 1) // 2
    loopi i arr =
      let s = (i + i) * (i + 3) + 3 in
      if s >= sz then arr else
      let tst = get i arr |> Maybe.withDefault True in
      if tst then loopi (i + 1) arr else
      let
        bp = i + i + 3
        cullc c iarr =
          if c >= sz then iarr else
          cullc (c + bp) (set c True iarr)
      in loopi (i + 1) (cullc s arr)
    cmpsts = loopi 0 (repeat sz False)
    cnvt (i, t) = if t then Nothing else Just <| i + i + 3
    oddprms = cmpsts |> Array.toIndexedList |> List.filterMap cnvt
  in 2 :: oddprms

module IntMap = Map.Make(Int)

let rec steps =
  4 :: 2 :: 4 :: 6 :: 2 :: 6 :: 4 :: 2 :: 4 :: 6 :: 6 :: 2 ::
  6 :: 4 :: 2 :: 6 :: 4 :: 6 :: 8 :: 4 :: 2 :: 4 :: 2 :: 4 ::
  8 :: 6 :: 4 :: 6 :: 2 :: 4 :: 6 :: 2 :: 6 :: 6 :: 4 :: 2 ::
  4 :: 6 :: 2 :: 6 :: 4 :: 2 :: 4 :: 2 :: 10 :: 2 :: 10 :: 2 :: steps

let not_in_wheel =
  let scan i =
    let rec loop n w = n < 223 && (i = n mod 210
      || match w with [] -> assert false | d :: w' -> loop (n + d) w')
    in not (loop 13 steps)
  in Array.init 210 scan

let seq_primes =
  let rec calc ms m p2 =
    if not_in_wheel.(m mod 210) || IntMap.mem m ms
    then calc ms (m + p2) p2
    else IntMap.add m p2 ms
  in
  let rec next c p pp ps whl ms () =
    match whl with
    | [] -> assert false
    | d :: w -> match IntMap.min_binding_opt ms with
        | Some (m, p2) when c = m ->
            next (c + d) p pp ps w (calc (IntMap.remove m ms) (m + p2) p2) ()
        | _ when c < pp -> Seq.Cons (c, next (c + d) p pp ps w ms)
        | _ -> match ps () with
            | Seq.Cons (p', ps') -> let p2' = p + p in
                next (c + d) p' (p' * p') ps' w (calc ms (pp + p2') p2') ()
            | _ -> assert false
  in
  let rec ps () = next 13 11 121 ps steps IntMap.empty () in
  Seq.cons 2 (Seq.cons 3 (Seq.cons 5 (Seq.cons 7 (Seq.cons 11 ps))))

let is_prime n =
  let rec test x =
    let q = n / x in x > q || x * q <> n && n mod (x + 2) <> 0 && test (x + 6)
  in if n < 5 then n lor 1 = 3 else n land 1 <> 0 && n mod 3 <> 0 && test 5

let () = Seq.ints 3
  |> Seq.filter is_prime
  |> Seq.take_while ((>) 1000)
  |> Seq.zip (Seq.ints 2)
  |> Seq.filter (fun (i, _) -> i land 1 = 1)
  |> Seq.scan (fun (_, pi, sum) (i, p) -> i, p, sum + p) (1, 2, 2)
  |> Seq.filter (fun (_, _, sum) -> is_prime sum)
  |> Seq.iter (fun (i, pi, sum) -> Printf.printf "p(%u) = %u, %u\n" i pi sum)

(* valid results for n in 0..119628 *)
let seq_hofstadter_q n =
  let a = Bigarray.(Array1.create int16_unsigned c_layout n) in
  let () =
    for i = 0 to pred n do
      a.{i} <- if i < 2 then 1 else a.{i - a.{pred i}} + a.{i - a.{i - 2}}
    done
  in
  Seq.init n (Bigarray.Array1.get a)

let () =
  let count_backflip (a, c) b = b, if b < a then succ c else c
  and hq = seq_hofstadter_q 100_000 in
  let () = Seq.(hq |> take 10 |> iter (Printf.printf " %u")) in
  let () = Seq.(hq |> drop 999 |> take 1 |> iter (Printf.printf "\n%u\n")) in
  hq |> Seq.fold_left count_backflip (0, 0) |> snd |> Printf.printf "%u\n"

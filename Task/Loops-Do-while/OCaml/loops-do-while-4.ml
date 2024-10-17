let do_while f p ~init =
  let rec loop v =
    let v = f v in
    if p v then loop v
  in
  loop init

do_while (fun v ->
            let v = succ v in
            Printf.printf "%d\n" v;
            (v))
         (fun v -> v mod 6 <> 0)
         ~init:0

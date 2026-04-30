let xorshift seed =
  let open Int64 in
  let state = ref seed in
  fun () ->
    let x = !state in
    let x = logxor x (shift_right x 12) in
    let x = logxor x (shift_left x 25) in
    let x = logxor x (shift_right x 27) in
    state := x;
    shift_right (mul x 0x2545F4914F6CDD1DL) 32 |> to_int32

let () =
  (* Five first elements in a sequence of integers *)
  let next_int = xorshift 1234567L in
  for i = 1 to 5 do
    Format.printf "%lu\n" (next_int ())
  done;
  (* Histogram of a hundred thousands elements in a sequence of floats *)
  (* OCaml has double-precision floats, i.e., 64 bits *)
  let counts = Array.make 5 0 in
  let next_float = xorshift 987654321L in
  for i = 1 to 100_000 do
    let f = Int32.to_float (next_float ()) /. float_of_int (1 lsl 32) in
    let f = if f < 0. then 1. +. f else f in
    let j = int_of_float (f *. 5.) in
    counts.(j) <- counts.(j) + 1
  done;
  Array.iteri (Format.printf "%d: %d\n") counts

let (>>) = Int64.shift_right_logical

let int32_bound n x =
  Int64.(to_int ((mul (logand (of_int32 x) 0xffffffffL) (of_int n)) >> 32))

let int32_rotate_right x n =
  Int32.(logor (shift_left x (-n land 31)) (shift_right_logical x n))

let pcg32_next inc st =
  Int64.(add (mul st 0x5851f42d4c957f2dL) inc)

let pcg32_output st =
  int32_rotate_right
    (Int32.logxor (Int64.to_int32 (st >> 27)) (Int64.to_int32 (st >> 45)))
    (Int64.to_int (st >> 59))

let seq_pcg32 (st, f) =
  let rec repeat st () = Seq.Cons (pcg32_output st, repeat (f st)) in
  repeat (f st)

let pcg32 seed_st seed_sq =
  let inc = Int64.(add (succ seed_sq) seed_sq) in
  Int64.add seed_st inc, pcg32_next inc

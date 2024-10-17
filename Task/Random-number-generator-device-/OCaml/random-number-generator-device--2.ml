let input_rand_int32 ic =
  let i1 = Int32.of_int (int_of_char (input_char ic))
  and i2 = Int32.of_int (int_of_char (input_char ic))
  and i3 = Int32.of_int (int_of_char (input_char ic))
  and i4 = Int32.of_int (int_of_char (input_char ic)) in
  let i2 = Int32.shift_left i2 8
  and i3 = Int32.shift_left i3 16
  and i4 = Int32.shift_left i4 24 in
  Int32.logor i1 (Int32.logor i2 (Int32.logor i3 i4))

let () =
  let ic = open_in "/dev/urandom" in
  let ri32 = input_rand_int32 ic in
  close_in ic;
  Printf.printf "%ld\n" ri32;
;;

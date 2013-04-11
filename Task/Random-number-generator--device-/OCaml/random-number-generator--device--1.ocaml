let input_rand_int ic =
  let i1 = int_of_char (input_char ic)
  and i2 = int_of_char (input_char ic)
  and i3 = int_of_char (input_char ic)
  and i4 = int_of_char (input_char ic) in
  i1 lor (i2 lsl 8) lor (i3 lsl 16) lor (i4 lsl 24)

let () =
  let ic = open_in "/dev/urandom" in
  let ri31 = input_rand_int ic in
  close_in ic;
  Printf.printf "%d\n" ri31;
;;

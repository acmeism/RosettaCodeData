(* description: Counts the number of bits set to 1
         input: the number to have its bit counted
        output: the number of bits set to 1 *)
let count_bits v =
  let rec aux c v =
    if v <= 0 then c
    else aux (c + (v land 1)) (v lsr 1)
  in
  aux 0 v

let () =
  for i = 0 to pred 256 do
    print_char (
      match (count_bits i) mod 2 with
      | 0 -> '0'
      | 1 -> '1'
      | _ -> assert false)
  done;
  print_newline ()

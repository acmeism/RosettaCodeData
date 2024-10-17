let write_file filename s =
  let oc = open_out filename in
  output_string oc s;
  close_out oc;
;;

let () =
  let filename = "test.txt" in
  let s = String.init 26 (fun i -> char_of_int (i + int_of_char 'A')) in
  write_file filename s

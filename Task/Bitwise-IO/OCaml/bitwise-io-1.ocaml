let write_7bit_string ~filename ~str =
  let oc = open_out filename in
  let ob = IO.output_bits(IO.output_channel oc) in
  String.iter (fun c -> IO.write_bits ob 7 (int_of_char c)) str;
  IO.flush_bits ob;
  close_out oc;
;;

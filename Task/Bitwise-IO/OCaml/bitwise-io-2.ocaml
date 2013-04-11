let read_7bit_string ~filename =
  let ic = open_in filename in
  let ib = IO.input_bits(IO.input_channel ic) in
  let buf = Buffer.create 2048 in
  try while true do
    let c = IO.read_bits ib 7 in
    Buffer.add_char buf (char_of_int c);
  done; ""
  with IO.No_more_input ->
    (Buffer.contents buf)

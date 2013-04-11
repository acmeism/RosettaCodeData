let greatest = List.fold_left max 0 ;;

(** number of bits needed to encode the integer m *)
let n_bits m =
  let m = float m in
  let rec aux n =
    let max = (2. ** n) -. 1. in
    if max >= m then int_of_float n
    else aux (n +. 1.0)
  in
  aux 1.0
;;

let write_compressed ~filename ~compressed =
  let nbits = n_bits(greatest compressed) in
  let oc = open_out filename in
  output_byte oc nbits;
  let ob = IO.output_bits(IO.output_channel oc) in
  List.iter (IO.write_bits ob nbits) compressed;
  IO.flush_bits ob;
  close_out oc;
;;

let read_compressed ~filename =
  let ic = open_in filename in
  let nbits = input_byte ic in
  let ib = IO.input_bits(IO.input_channel ic) in
  let rec loop acc =
    try
      let code = IO.read_bits ib nbits in
      loop (code::acc)
    with _ -> List.rev acc
  in
  let compressed = loop [] in
  let result = decompress ~compressed in
  let buf = Buffer.create 2048 in
  List.iter (Buffer.add_string buf) result;
  (Buffer.contents buf)
;;

let print_jpeg ~img ?(quality=96) () =
  let cmd = Printf.sprintf "cjpeg -quality %d" quality in
  (*
  let cmd = Printf.sprintf "ppmtojpeg -quality %d" quality in
  let cmd = Printf.sprintf "convert ppm:- -quality %d jpg:-" quality in
  *)
  let ic, oc = Unix.open_process cmd in
  output_ppm ~img ~oc;
  try
    while true do
      let c = input_char ic in
      print_char c
    done
  with End_of_file -> ()
;;

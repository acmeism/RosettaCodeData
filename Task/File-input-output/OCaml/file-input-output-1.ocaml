let () =
  let ic = open_in "input.txt" in
  let oc = open_out "output.txt" in
  try
    while true do
      let s = input_line ic in
      output_string oc s;
      output_char oc '\n';
    done
  with End_of_file ->
    close_in ic;
    close_out oc;
;;

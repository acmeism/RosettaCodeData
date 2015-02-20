let () =
  let ic = open_in "input.txt" in
  let oc = open_out "output.txt" in
  try
    while true do
      let c = input_char ic in
      output_char oc c
    done
  with End_of_file ->
    close_in ic;
    close_out oc;
;;

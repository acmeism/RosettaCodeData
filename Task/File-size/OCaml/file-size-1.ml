let printFileSize filename =
  let ic = open_in filename in
  Printf.printf "%d\n" (in_channel_length ic);
  close_in ic ;;

printFileSize "input.txt" ;;
printFileSize "/input.txt" ;;

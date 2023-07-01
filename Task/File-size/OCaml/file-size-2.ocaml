let printLargeFileSize filename =
  let ic = open_in filename in
  Printf.printf "%Ld\n" (LargeFile.in_channel_length ic);
  close_in ic ;;

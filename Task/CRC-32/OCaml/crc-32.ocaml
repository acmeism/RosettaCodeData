let () =
  let s = "The quick brown fox jumps over the lazy dog" in
  let crc = Zlib.update_crc 0l s 0 (String.length s) in
  Printf.printf "crc: %lX\n" crc

let load_big_file filename =
  let fd = Unix.openfile filename [Unix.O_RDONLY] 0o640 in
  let len = Unix.lseek fd 0 Unix.SEEK_END in
  let _ = Unix.lseek fd 0 Unix.SEEK_SET in
  let shared = false in  (* modifications are done in memory only *)
  let bstr = Bigarray.Array1.map_file fd
               Bigarray.char Bigarray.c_layout shared len in
  Unix.close fd;
  (bstr)

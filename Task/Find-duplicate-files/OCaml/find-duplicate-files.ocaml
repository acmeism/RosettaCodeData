let readdir_or_empty dir =
  try Sys.readdir dir
  with Sys_error e ->
    prerr_endline ("Could not read dir " ^ dir ^ ": " ^ e);
    [||]

let directory_walk root func =
  let rec aux dir =
    readdir_or_empty dir
    |> Array.iter (fun filename ->
           let path = Filename.concat dir filename in
           let open Unix in
           let stat = lstat path in
           match stat.st_kind with
           | S_DIR -> aux path
           | S_REG -> func path stat
           | _ -> ())
  in
  aux root

let rec input_retry ic buf pos len =
  let count = input ic buf pos len in
  if count = 0 || count = len then count + pos
  else input_retry ic buf (pos + count) (len - count)

let with_file_in_bin fn f =
  let fh = open_in_bin fn in
  Fun.protect ~finally:(fun () -> close_in fh) (fun () -> f fh)

let is_really_same_file fn1 fn2 =
  with_file_in_bin fn1 (fun fh1 ->
      with_file_in_bin fn2 (fun fh2 ->
          let len = 2048 in
          let buf1 = Bytes.create len in
          let buf2 = Bytes.create len in
          let rec aux () =
            let read1 = input_retry fh1 buf1 0 len in
            let read2 = input_retry fh2 buf2 0 len in
            if read1 <> read2 || buf1 <> buf2 then false
            else if read1 = 0 then true
            else aux ()
          in
          aux ()))

let () =
  let tbl = Hashtbl.create 128 in
  let seen = Hashtbl.create 128 in
  let min_size = int_of_string Sys.argv.(2) in
  directory_walk Sys.argv.(1) (fun path stat ->
      try
        let identity_tuple = (stat.st_dev, stat.st_ino) in
        match Hashtbl.find_opt seen identity_tuple with
        | Some existing ->
            print_endline
              ("File " ^ existing ^ " is the same hard link as " ^ path)
        | None -> (
            Hashtbl.add seen identity_tuple path;
            let size = stat.st_size in
            if size >= min_size then
              let digest = Digest.file path in
              Hashtbl.find_all tbl digest
              |> List.find_opt (is_really_same_file path)
              |> function
              | Some existing ->
                  print_endline ("File " ^ existing ^ " matches " ^ path)
              | None -> Hashtbl.add tbl digest path)
      with Sys_error e -> prerr_endline ("Could not hash " ^ path ^ ": " ^ e))

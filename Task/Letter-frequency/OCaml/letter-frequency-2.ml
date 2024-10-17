open Batteries

let frequency file =
  let freq = Hashtbl.create 52 in
    File.with_file_in file
      (Enum.iter (fun c -> Hashtbl.modify_def 1 c succ freq) % Text.chars_of);
    List.iter (fun (k,v) -> Text.write_text stdout k;
                            Printf.printf " %d\n" v)
    @@ List.sort (fun (_,v) (_,v') -> compare v v')
    @@ Hashtbl.fold (fun k v l -> (Text.of_uchar k,v) :: l) freq []

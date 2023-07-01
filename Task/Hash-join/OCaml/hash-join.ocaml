let hash_join table1 f1 table2 f2 =
  let h = Hashtbl.create 42 in
  (* hash phase *)
  List.iter (fun s ->
    Hashtbl.add h (f1 s) s) table1;
  (* join phase *)
  List.concat (List.map (fun r ->
    List.map (fun s -> s, r) (Hashtbl.find_all h (f2 r))) table2)

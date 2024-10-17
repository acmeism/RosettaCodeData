let hash = Hashtbl.create 0;;
List.iter (fun (key, value) -> Hashtbl.add hash key value)
  ["foo", 5; "bar", 10; "baz", 15];;

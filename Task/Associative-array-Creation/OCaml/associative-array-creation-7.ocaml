let dict = ["foo", 5; "bar", 10; "baz", 15]

(* retrieve value *)
let bar_num = try List.assoc "bar" dict with Not_found -> 0;;

(* see if key exists *)
print_endline (if List.mem_assoc "foo" dict then "key found" else "key missing")

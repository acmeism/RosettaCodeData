let caml_query () =
  let s = "Here am I" in
  (s, String.length s)
;;

let () =
  Callback.register "Query function cb" caml_query;
;;

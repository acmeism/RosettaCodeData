let matched pat str =
  try ignore(Pcre.exec ~pat str); (true)
  with Not_found -> (false)
;;

let () =
  Printf.printf "matched = %b\n" (matched "string$" "I am a string");
  Printf.printf "Substitute: %s\n"
    (Pcre.replace ~pat:"original" ~templ:"modified" "I am the original string")
;;

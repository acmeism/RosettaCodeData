module CharMap = Map.Make (Char);;
let map = CharMap.empty;;
let map = CharMap.add 'A' 1 map;;
let map = CharMap.add 'B' 2 map;;
let map = CharMap.add 'C' 3 map;;

(* iterate over pairs *)
CharMap.iter (fun k v -> Printf.printf "key: %c - value: %d\n" k v) map ;;

(* in functional programming it is often more useful to fold over the elements *)
CharMap.fold (fun k v acc -> acc ^ Printf.sprintf "key: %c - value: %d\n" k v) map "Elements:\n" ;;

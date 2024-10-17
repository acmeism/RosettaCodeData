let map = Hashtbl.create 42;;
Hashtbl.add map 'A' 1;;
Hashtbl.add map 'B' 2;;
Hashtbl.add map 'C' 3;;

(* iterate over pairs *)
Hashtbl.iter (fun k v -> Printf.printf "key: %c - value: %d\n" k v) map ;;

(* in functional programming it is often more useful to fold over the elements *)
Hashtbl.fold (fun k v acc -> acc ^ Printf.sprintf "key: %c - value: %d\n" k v) map "Elements:\n" ;;

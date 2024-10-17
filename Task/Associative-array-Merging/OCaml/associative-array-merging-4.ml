(* Updates the base table with the bindings from add *)
let hash_merge (base : (string, ty) Hashtbl.t) (add : (string, ty) Hashtbl.t) : unit =
    Hashtbl.iter (Hashtbl.replace base) add

let print_hashtbl t =
    Hashtbl.iter print_pair t

let h1 : (string, ty) Hashtbl.t = Hashtbl.create 10 ;;
Hashtbl.add h1 "name" (TString "Rocket Skates") ;;
Hashtbl.add h1 "price" (TFloat 12.75) ;;
Hashtbl.add h1 "color" (TString "yellow") ;;

let h2 : (string, ty) Hashtbl.t = Hashtbl.create 10 ;;
Hashtbl.add h2 "price" (TFloat 15.25) ;;
Hashtbl.add h2 "color" (TString "red") ;;
Hashtbl.add h2 "year" (TInt 1974) ;;

hash_merge h1 h2 ;;

print_hashtbl h1 ;;

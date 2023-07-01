module StringMap = Map.Make(String) ;;

let print_map = StringMap.iter print_pair ;;

let map_merge (base : ty StringMap.t) (add : ty StringMap.t) : ty StringMap.t =
    StringMap.union (fun key v1 v2 -> Some v2) base add
;;

let m1 = StringMap.(
    empty
    |> add "name" (TString "Rocket Skates")
    |> add "price" (TFloat 12.75)
    |> add "color" (TString "yellow")
) ;;

let m2 = StringMap.(
    empty
    |> add "price" (TFloat 15.25)
    |> add "color" (TString "red")
    |> add "year" (TInt 1974)
) ;;

let m' = map_merge m1 m2 ;;

print_map m' ;;

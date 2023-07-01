let l1 : assoc list = [
    ("name", TString "Rocket Skates");
    ("price", TFloat 12.75);
    ("color", TString "yellow")
] ;;

let l2 : assoc list = [
    ("price", TFloat 15.25);
    ("color", TString "red");
    ("year",  TInt 1974)
] ;;

let rec merge_assoc_list (base_list : assoc list) (add_list : assoc list) : assoc list =
    List.fold_left
        (fun l (key, val_) ->
            (key, val_) :: (List.remove_assoc key l)
        )
        base_list
        add_list
;;

let l' = merge_assoc_list l1 l2 ;;

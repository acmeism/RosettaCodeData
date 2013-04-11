module String = struct
   type t = string
   let compare = Pervasives.compare
end
module StringMap = Map.Make(String);;

let map =
  List.fold_left
    (fun map (key, value) -> StringMap.add key value map)
    StringMap.empty
    ["foo", 5; "bar", 10; "baz", 15]
;;

module StringMap = Map.Make (String);;

let keys = [ "foo"; "bar"; "baz" ]
and vals = [ 16384; 32768; 65536 ]
and map = StringMap.empty;;

let map = List.fold_right2 StringMap.add keys vals map;;

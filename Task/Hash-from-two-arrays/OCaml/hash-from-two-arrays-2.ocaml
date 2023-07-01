let keys = [| "foo"; "bar"; "baz" |]
and vals = [| 16384; 32768; 65536 |]
and hash = Hashtbl.create 0;;

Array.iter2 (Hashtbl.add hash) keys vals;;

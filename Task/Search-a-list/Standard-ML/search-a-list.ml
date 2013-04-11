fun find_index (pred, lst) = let
  fun loop (n, [])    = NONE
    | loop (n, x::xs) = if pred x then SOME n
                                  else loop (n+1, xs)
in
  loop (0, lst)
end;

val haystack = ["Zig","Zag","Wally","Ronald","Bush","Krusty","Charlie","Bush","Bozo"];

app (fn needle =>
       case find_index (fn x => x = needle, haystack) of
            SOME i => print (Int.toString i ^ " " ^ needle ^ "\n")
          | NONE   => print (needle ^ " is not in haystack\n"))
    ["Washington", "Bush"];

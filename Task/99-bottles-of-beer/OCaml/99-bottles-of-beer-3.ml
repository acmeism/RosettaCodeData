(* A basic "Writer" monoid with emit *)
module Writer = struct
  type 'a t = 'a * string
  let ( >>= ) (x,s) f = let (y,s') = f x in (y, s ^ s')
  let return x = (x,"")
  let emit (x,s) = print_string s; x
end

(* Utility functions for handling strings and grammar *)
let line s    = (String.capitalize s) ^ ".\n"
let count     = function 0 -> "no more" | n -> string_of_int n
let plural    = function 1 -> "" | _ -> "s"
let specify   = function 1 -> "it" | _ -> "one"
let bottles n = count n ^ " bottle" ^ plural n ^ " of beer"

(* Actions, expressed as an int * string, for Writer *)
let report n  = (n, line (bottles n ^ " on the wall, " ^ bottles n))
let take n    = (n-1, "Take " ^ specify n ^ " down and pass it around")
let summary n = (n, ", " ^ bottles n ^ " on the wall.\n\n")
let shop      = (99, "Go to the store and buy some more")

let rec verse state =
  Writer.(state >>= report >>= function 0 -> shop >>= summary (* ends here *)
                                      | n -> take n >>= summary |> verse)
let sing start =
  Writer.(emit (verse (return start)))

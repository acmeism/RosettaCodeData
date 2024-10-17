(* One can build a function from the idea above, catching the exception *)

let rec_limit () =
  let last = ref 0 in
  let rec f i =
    last := i;
    1 + f (i + 1)
  in
  try (f 0)
  with Stack_overflow -> !last
;;

rec_limit ();;
262064

(* Since with have eaten some stack with this function, the result is slightly lower.
But now it may be used inside any function to get the available stack space *)

let match1 s1 s2 =
  let len1 = String.length s1
  and len2 = String.length s2 in
  if len1 < len2 then false else
    let sub = String.sub s1 0 len2 in
    (sub = s2)

(* testing in the top-level:

 # match1 "Hello" "Hello World!" ;;
 - : bool = false
 # match1 "Hello World!" "Hello" ;;
 - : bool = true
*)

let match2 s1 s2 =
  let len1 = String.length s1
  and len2 = String.length s2 in
  if len1 < len2 then false else
    let rec aux i =
      if i < 0 then false else
        let sub = String.sub s1 i len2 in
        if (sub = s2) then true else aux (pred i)
    in
    aux (len1 - len2)

(*
 # match2 "It's raining, Hello World!" "umbrella" ;;
 - : bool = false
 # match2 "It's raining, Hello World!" "Hello" ;;
 - : bool = true
*)

let match3 s1 s2 =
  let len1 = String.length s1
  and len2 = String.length s2 in
  if len1 < len2 then false else
    let sub = String.sub s1 (len1 - len2) len2 in
    (sub = s2)

(*
 # match3 "Hello World" "Hello" ;;
 - : bool = false
 # match3 "Hello World" "World" ;;
 - : bool = true
*)

let match2_loc s1 s2 =
  let len1 = String.length s1
  and len2 = String.length s2 in
  if len1 < len2 then (false, -1) else
    let rec aux i =
      if i < 0 then (false, -1) else
        let sub = String.sub s1 i len2 in
        if (sub = s2) then (true, i) else aux (pred i)
    in
    aux (len1 - len2)

(*
 # match2_loc "The sun's shining, Hello World!" "raining" ;;
 - : bool * int = (false, -1)
 # match2_loc "The sun's shining, Hello World!" "shining" ;;
 - : bool * int = (true, 10)
*)

let match2_num s1 s2 =
  let len1 = String.length s1
  and len2 = String.length s2 in
  if len1 < len2 then (false, 0) else
    let rec aux i n =
      if i < 0 then (n <> 0, n) else
        let sub = String.sub s1 i len2 in
        if (sub = s2)
        then aux (pred i) (succ n)
        else aux (pred i) (n)
    in
    aux (len1 - len2) 0

(*
 # match2_num "This cloud looks like a camel, \
     that other cloud looks like a llama" "stone" ;;
 - : bool * int = (false, 0)
 # match2_num "This cloud looks like a camel, \
     that other cloud looks like a llama" "cloud" ;;
 - : bool * int = (true, 2)
*)

let popcount n =
  let rec aux acc = function
    | 0 -> acc
    | x -> aux (succ acc) (x land pred x)
  in
  aux 0 n

let is_parity p x =
  p = 1 land popcount x

(* test code *)

let powers3_seq () =
  Seq.unfold (fun x -> Some (popcount x, x * 3)) 1

let parity_seq p =
  Seq.(filter (is_parity p) (ints 0))

let print_seq_30 s =
  Seq.(s |> take 30 |> map string_of_int)
  |> List.of_seq |> String.concat " " |> print_endline

let () = print_seq_30 (powers3_seq ())
let () = print_seq_30 (parity_seq 0)
let () = print_seq_30 (parity_seq 1)

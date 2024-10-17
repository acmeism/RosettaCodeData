module IntMap = Map.Make(Int)

let seq_lines ch =
  let rec repeat () =
    match input_line ch with
    | s -> Seq.Cons (s, repeat)
    | exception End_of_file -> Nil
  in repeat

(* simply use bijective numeration in base 8 for keys *)

let key_of_char = function
  | 'a' .. 'c' -> Some 1
  | 'd' .. 'f' -> Some 2
  | 'g' .. 'i' -> Some 3
  | 'j' .. 'l' -> Some 4
  | 'm' .. 'o' -> Some 5
  | 'p' .. 's' -> Some 6
  | 't' .. 'v' -> Some 7
  | 'w' .. 'z' -> Some 8
  | _ -> None

let keys_of_word =
  let next k c =
    Option.bind (key_of_char c) (fun d -> Option.map (fun k -> k lsl 3 + d) k)
  in String.fold_left next (Some 0)

let update m k =
  IntMap.update k (function Some n -> Some (succ n) | None -> Some 1) m

let map_from ch =
  seq_lines ch |> Seq.filter_map keys_of_word |> Seq.fold_left update IntMap.empty

let count _ n (words, keys, txtns) =
  words + n, succ keys, if n > 1 then succ txtns else txtns

let show src (words, keys, txtns) = Printf.printf "\
  There are %u words in %s which can be represented by the digit key mapping.\n\
  They require %u digit combinations to represent them.\n\
  %u digit combinations represent Textonyms.\n" words src keys txtns

let () =
  show "stdin" (IntMap.fold count (map_from stdin) (0, 0, 0))

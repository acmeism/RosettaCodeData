module StrSet = Set.Make(String)

let read_line_seq ch =
  let rec repeat () =
    match input_line ch with
    | s -> Seq.Cons (s, repeat)
    | exception End_of_file -> Nil
  in repeat

let string_rev s =
  let last = pred (String.length s) in
  String.init (succ last) (fun i -> s.[last - i])

let get_anadromes set =
  let aux s =
    let r = string_rev s in
    if s < r && StrSet.mem r set
    then Some (s, r)
    else None
  in
  Seq.filter_map aux (StrSet.to_seq set)

let () = read_line_seq stdin |> Seq.filter (fun s -> String.length s > 6)
  |> Seq.map String.lowercase_ascii |> StrSet.of_seq |> get_anadromes
  |> Seq.iter (fun (s, r) -> Printf.printf "%9s | %s\n" s r)

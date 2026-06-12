module StrSet = Set.Make(String)

let seq_lines ch =
  let rec repeat () =
    match input_line ch with
    | s -> Seq.Cons (s, repeat)
    | exception End_of_file -> Nil
  in repeat

let min_len l s =
  l <= String.length s

let get_alternade set s =
  let s0 = String.init (succ (String.length s) lsr 1) (fun i -> s.[i + i])
  and s1 = String.init (String.length s lsr 1) (fun i -> s.[i + succ i]) in
  if StrSet.mem s0 set && StrSet.mem s1 set
  then Some (Printf.sprintf "%s | %s %s" s s0 s1) else None

let () =
  let set = seq_lines stdin |> Seq.filter (min_len 3) |> StrSet.of_seq in
  StrSet.to_seq set |> Seq.filter (min_len 6)
  |> Seq.filter_map (get_alternade set) |> Seq.iter print_endline

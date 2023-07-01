let () =
  let n =
    try int_of_string Sys.argv.(1)
    with _ -> 10
  in
  let ic = open_in "135-0.txt" in
  let h = Hashtbl.create 97 in
  let w = Str.regexp "[^A-Za-zéèàêâôîûœ]+" in
  try
    while true do
      let line = input_line ic in
      let words = Str.split w line in
      List.iter (fun word ->
        let word = String.lowercase_ascii word in
        match Hashtbl.find_opt h word with
        | None -> Hashtbl.add h word 1
        | Some x -> Hashtbl.replace h word (succ x)
      ) words
    done
  with End_of_file ->
    close_in ic;
    let l = Hashtbl.fold (fun word count acc -> (word, count)::acc) h [] in
    let s = List.sort (fun (_, c1) (_, c2) -> compare c2 c1) l in
    let r = List.init n (fun i -> List.nth s i) in
    List.iter (fun (word, count) ->
      Printf.printf "%d  %s\n" count word
    ) r

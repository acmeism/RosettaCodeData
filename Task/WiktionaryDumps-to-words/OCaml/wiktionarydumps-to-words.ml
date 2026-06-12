let () =
  let i = Xmlm.make_input ~strip:true (`Channel stdin) in
  let title = ref "" in
  let tag_path = ref [] in
  let push_tag tag =
    tag_path := tag :: !tag_path
  in
  let pop_tag () =
    match !tag_path with [] -> ()
    | _ :: tl -> tag_path := tl
  in
  let last_tag_is tag =
    match !tag_path with [] -> false
    | hd :: _ -> hd = tag
  in
  let reg = Str.regexp_string "==French==" in
  let matches s =
    try let _ = Str.search_forward reg s 0 in true
    with Not_found -> false
  in
  while not (Xmlm.eoi i) do
    match Xmlm.input i with
    | `Dtd dtd -> ()
    | `El_start ((uri, tag_name), attrs) -> push_tag tag_name
    | `El_end -> pop_tag ()
    | `Data s ->
        if last_tag_is "title"
        then title := s;
        if last_tag_is "text"
        then begin
          if matches s
          then print_endline !title
        end
  done

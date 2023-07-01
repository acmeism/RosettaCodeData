let rec find_option h v =
  try Some(Hashtbl.find h v)
  with Not_found -> None

let rec a bounds caller todo m n =
  match m, n with
  | 0, n ->
      let r = (n+1) in
      ( match todo with
        | [] -> r
        | (m,n)::todo ->
            List.iter (fun k ->
              if not(Hashtbl.mem bounds k)
              then Hashtbl.add bounds k r) caller;
            a bounds [] todo m n )

  | m, 0 ->
      a bounds caller todo (m-1) 1

  | m, n ->
      match find_option bounds (m, n-1) with
      | Some a_rec ->
          let caller = (m,n)::caller in
          a bounds caller todo (m-1) a_rec
      | None ->
          let todo = (m,n)::todo
          and caller = [(m, n-1)] in
          a bounds caller todo m (n-1)

let a = a (Hashtbl.create 42 (* arbitrary *) ) [] [] ;;

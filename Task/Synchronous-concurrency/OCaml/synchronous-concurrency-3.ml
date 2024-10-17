let printer lines_source count_target =
  let rec aux i =
    match sync (receive lines_source) with
      | Some line -> print_endline line; aux ( i + 1 )
      | None      -> sync (send count_target i)
  in aux 0

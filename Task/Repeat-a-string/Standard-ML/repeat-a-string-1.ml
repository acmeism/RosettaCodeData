fun string_repeat (s, n) =
  concat (List.tabulate (n, fn _ => s))
;

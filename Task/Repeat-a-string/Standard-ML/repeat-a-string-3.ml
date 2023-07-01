fun char_repeat (c, n) =
  implode (List.tabulate (n, fn _ => c))
;

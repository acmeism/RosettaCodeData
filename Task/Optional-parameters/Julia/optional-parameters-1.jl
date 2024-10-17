sorttable(T; ordering=<, column=1, reverse=false) =
  sort(T, by = t -> t[column], lt = reverse ? (a,b) -> ordering(b,a) : ordering)
sorttable(T, ordering=<, column=1, reverse=false) =
  sorttable(T, ordering=ordering, column=column, reverse=reverse)

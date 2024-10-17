let rec transpose m =
  assert (m <> []);
  if List.mem [] m then
    []
  else
    List.map List.hd m :: transpose (List.map List.tl m)

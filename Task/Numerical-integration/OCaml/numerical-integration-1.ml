let integrate f a b steps meth =
  let h = (b -. a) /. float_of_int steps in
  let rec helper i s =
    if i >= steps then s
    else helper (succ i) (s +. meth f (a +. h *. float_of_int i) h)
  in
  h *. helper 0 0.

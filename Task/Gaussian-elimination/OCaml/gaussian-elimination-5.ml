let mul m v =
  Array.mapi (fun i u ->
    Array.foldi_left (fun j sum uj ->
      sum +. uj *. v.(j)
    ) 0. u
  ) m

let sub u v = Array.mapi (fun i e -> e -. v.(i)) u

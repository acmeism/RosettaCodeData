let polydiv f g =
  let rec aux f s q =
    let ddif = (deg f) - (deg s) in
    if ddif < 0 then (q, f) else
      let k = (List.hd f) /. (List.hd s) in
      let ks = List.map (( *.) k) (shift ddif s) in
      let q' = zip (+.) q (shift ddif [k])
      and f' = norm (List.tl (zip (-.) f ks)) in
      aux f' s q' in
  aux (norm f) (norm g) []

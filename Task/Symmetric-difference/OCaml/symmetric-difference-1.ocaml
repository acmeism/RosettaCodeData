let unique lst =
  let f lst x = if List.mem x lst then lst else x::lst in
  List.rev (List.fold_left f [] lst)

let ( -| ) a b =
  unique (List.filter (fun v -> not (List.mem v b)) a)

let ( -|- ) a b = (b -| a) @ (a -| b)

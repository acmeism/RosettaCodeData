let h = Hashtbl.create 4001

let a m n =
  try Hashtbl.find h (m, n)
  with Not_found ->
    let res = a (m, n) in
    Hashtbl.add h (m, n) res;
    (res)

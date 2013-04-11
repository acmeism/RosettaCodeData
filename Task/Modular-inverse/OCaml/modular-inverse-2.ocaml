let rec gcd_ext a = function
  | 0 -> (1, 0, a)
  | b ->
      let s, t, g = gcd_ext b (a mod b) in
      (t, s - (a / b) * t, g)

let mod_inv a m =
  let mk_pos x = if x < 0 then x + m else x in
  match gcd_ext a m with
  | i, _, 1 -> mk_pos i
  | _ -> failwith "mod_inv"

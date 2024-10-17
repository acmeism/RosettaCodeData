let mul_inv a = function 1 -> 1 | b ->
  let rec aux a b x0 x1 =
    if a <= 1 then x1 else
    if b = 0 then failwith "mul_inv" else
    aux b (a mod b) (x1 - (a / b) * x0) x0
  in
  let x = aux a b 0 1 in
  if x < 0 then x + b else x

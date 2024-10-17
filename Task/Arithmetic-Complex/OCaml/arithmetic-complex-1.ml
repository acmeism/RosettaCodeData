open Complex

let print_complex z =
  Printf.printf "%f + %f i\n" z.re z.im

let () =
  let a = { re = 1.0; im = 1.0 }
  and b = { re = 3.14159; im = 1.25 } in
  print_complex (add a b);
  print_complex (mul a b);
  print_complex (inv a);
  print_complex (neg a);
  print_complex (conj a)

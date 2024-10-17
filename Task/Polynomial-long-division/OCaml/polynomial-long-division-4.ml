let _ =
  let f = [1.0; -4.0; 6.0; 5.0; 3.0] and g = [1.0; 2.0; 1.0] in
  let q, r = polydiv f g in
  Printf.printf
    " (%s) div (%s)\ngives\nquotient:\t(%s)\nremainder:\t(%s)\n"
    (str_poly f) (str_poly g) (str_poly q) (str_poly r)

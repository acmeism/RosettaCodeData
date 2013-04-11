let () =
  Complex.(
    let print txt z = Printf.printf "%s = %s\n" txt (to_string z) in
    let a = 1 + I
    and b = 3 + 7I in
    print "a + b" (a + b);
    print "a - b" (a - b);
    print "a * b" (a * b);
    print "a / b" (a / b);
    print "-a" (- a);
    print "conj a" (conj a);
    print "a^b" (a**b);
    Printf.printf "norm a = %g\n" (float(abs a));
  )

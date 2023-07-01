let approx_eq v1 v2 epsilon =
  Float.abs (v1 -. v2) < epsilon

let test a b =
  let epsilon = 1e-18 in
  Printf.printf "%g, %g => %b\n" a b (approx_eq a b epsilon)

let () =
  test 100000000000000.01 100000000000000.011;
  test 100.01 100.011;
  test (10000000000000.001 /. 10000.0) 1000000000.0000001000;
  test 0.001 0.0010000001;
  test 0.000000000000000000000101 0.0;
  test ((sqrt 2.0) *. (sqrt 2.0)) 2.0;
  test (-. (sqrt 2.0) *. (sqrt 2.0)) (-2.0);
  test 3.14159265358979323846 3.14159265358979324;
;;

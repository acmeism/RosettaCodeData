let pi = 3.14159_26535_89793_23846_2643

let deg2rad d =
  d *. pi /. 180.0

let rad2deg r =
  r *. 180.0 /. pi

let mean_angle angles =
  let rad_angles = List.map deg2rad angles in
  let sum_sin = List.fold_left (fun sum a -> sum +. sin a) 0.0 rad_angles
  and sum_cos = List.fold_left (fun sum a -> sum +. cos a) 0.0 rad_angles
  in
  rad2deg (atan2 sum_sin sum_cos)

let test angles =
  Printf.printf "The mean angle of [%s] is: %g degrees\n"
    (String.concat "; " (List.map (Printf.sprintf "%g") angles))
    (mean_angle angles)

let () =
  test [350.0; 10.0];
  test [90.0; 180.0; 270.0; 360.0];
  test [10.0; 20.0; 30.0];
;;

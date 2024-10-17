let get_diff b1 b2 =
  let r = mod_float (b2 -. b1) 360.0 in
  if r < -180.0
  then r +. 360.0
  else if r >= 180.0
  then r -. 360.0
  else r

let () =
  print_endline "Input in -180 to +180 range";
  Printf.printf " %g\n" (get_diff 20.0 45.0);
  Printf.printf " %g\n" (get_diff (-45.0) 45.0);
  Printf.printf " %g\n" (get_diff (-85.0) 90.0);
  Printf.printf " %g\n" (get_diff (-95.0) 90.0);
  Printf.printf " %g\n" (get_diff (-45.0) 125.0);
  Printf.printf " %g\n" (get_diff (-45.0) 145.0);
  Printf.printf " %g\n" (get_diff (-45.0) 125.0);
  Printf.printf " %g\n" (get_diff (-45.0) 145.0);
  Printf.printf " %g\n" (get_diff 29.4803 (-88.6381));
  Printf.printf " %g\n" (get_diff (-78.3251) (-159.036));

  print_endline "Input in wider range";
  Printf.printf " %g\n" (get_diff (-70099.74233810938) 29840.67437876723);
  Printf.printf " %g\n" (get_diff (-165313.6666297357) 33693.9894517456);
  Printf.printf " %g\n" (get_diff 1174.8380510598456 (-154146.66490124757));
  Printf.printf " %g\n" (get_diff 60175.77306795546 42213.07192354373);
;;

let rec inf_loop() =
  print_endline "SPAM";
  inf_loop()
in
inf_loop()

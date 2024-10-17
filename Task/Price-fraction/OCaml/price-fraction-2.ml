let () =
  let ok_tests = [
    (0.3793, 0.54);
    (0.4425, 0.58);
    (0.0746, 0.18);
    (0.6918, 0.78);
    (0.2993, 0.44);
    (0.5486, 0.66);
    (0.7848, 0.86);
    (0.9383, 0.98);
    (0.2292, 0.38);
  ] in
  Printf.printf " input   res   ok\n";
  List.iter (fun (v,ok) ->
    let r = price_fraction v in
    Printf.printf " %6g  %g  %b\n" v r (r = ok);
  ) ok_tests;
;;

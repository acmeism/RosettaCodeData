let () =
  (* cache factorials from 0 to 11 *)
  let fact = Array.make 12 0 in
  fact.(0) <- 1;
  for n = 1 to pred 12 do
    fact.(n) <- fact.(n-1) * n;
  done;

  for b = 9 to 12 do
    Printf.printf "The factorions for base %d are:\n" b;
    for i = 1 to pred 1_500_000 do
      let sum = ref 0 in
      let j = ref i in
      while !j > 0 do
        let d = !j mod b in
        sum := !sum + fact.(d);
        j := !j / b;
      done;
      if !sum = i then (print_int i; print_string " ")
    done;
    print_string "\n\n";
  done

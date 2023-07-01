let () =
  let cls = Array.init 10 (fun i -> (function () -> i * i)) in
  Random.self_init ();
  for i = 1 to 6 do
    let x = Random.int 9 in
    Printf.printf " fun.(%d) = %d\n" x (cls.(x) ());
  done

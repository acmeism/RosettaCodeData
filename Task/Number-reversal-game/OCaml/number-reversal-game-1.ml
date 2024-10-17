let swap ar i j =
  let tmp = ar.(i) in
  ar.(i) <- ar.(j);
  ar.(j) <- tmp

let shuffle ar =
  for i = pred(Array.length ar) downto 1 do
    let j = Random.int (i + 1) in
    swap ar i j
  done

let reversal ar n =
  for i = 0 to pred(n/2) do
    let j = (pred n) - i in
    swap ar i j
  done

let sorted ar =
  try
    let prev = ref ar.(0) in
    for i = 1 to pred(Array.length ar) do
      if ar.(i) < !prev then raise Exit;
      prev := ar.(i)
    done;
    (true)
  with Exit ->
    (false)

let () =
  print_endline "\
  Number Reversal Game
  Sort the numbers in ascending order by repeatedly
  flipping sets of numbers from the left.";
  Random.self_init();
  let nums = Array.init 9 (fun i -> succ i) in
  while sorted nums do shuffle nums done;
  let n = ref 1 in
  while not(sorted nums) do
    Printf.printf "#%2d: " !n;
    Array.iter (Printf.printf " %d") nums;
    print_newline();
    let r = read_int() in
    reversal nums r;
    incr n;
  done;
  print_endline "Congratulations!";
  Printf.printf "You took %d attempts to put the digits in order.\n" !n;
;;

let sma_create period =
  let q = Queue.create ()
  and sum = ref 0.0 in
  fun x ->
    sum := !sum +. x;
    Queue.push x q;
    if Queue.length q > period then
      sum := !sum -. Queue.pop q;
    !sum /. float (Queue.length q)

let () =
  let periodLst = [ 3; 5 ] in
  let series = [ 1.; 2.; 3.; 4.; 5.; 5.; 4.; 3.; 2.; 1. ] in

  List.iter (fun d ->
    Printf.printf "SIMPLE MOVING AVERAGE: PERIOD = %d\n" d;
    let sma = sma_create d in
    List.iter (fun x ->
      Printf.printf "Next number = %-2g, SMA = %g\n" x (sma x);
    ) series;
    print_newline ();
  ) periodLst

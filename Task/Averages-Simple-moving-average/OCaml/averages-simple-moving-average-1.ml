let sma (n, s, q) x =
  let l = Queue.length q and s = s +. x in
  Queue.push x q;
  if l < n then
    (n, s, q), s /. float (l + 1)
  else (
    let s = s -. Queue.pop q in
    (n, s, q), s /. float l
  )

let _ =
  let periodLst = [ 3; 5 ] in
  let series = [ 1.; 2.; 3.; 4.; 5.; 5.; 4.; 3.; 2.; 1. ] in

  List.iter (fun d ->
    Printf.printf "SIMPLE MOVING AVERAGE: PERIOD = %d\n" d;
    ignore (
      List.fold_left (fun o x ->
	let o, m = sma o x in
	Printf.printf "Next number = %-2g, SMA = %g\n" x m;
	o
      ) (d, 0., Queue.create ()) series;
    );
    print_newline ();
  ) periodLst

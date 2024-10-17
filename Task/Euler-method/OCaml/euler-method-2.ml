(* Wrapping up the parameters in a "cool" function: *)
let cool = euler (newton_cooling ~k:0.07 ~tr:20.)

(* Similarly for the analytic solution: *)
let analytic = analytic_solution ~k:0.07 ~tr:20. ~t0:100.

(* (Just a loop) Apply recurrence function on state, until some condition *)
let recur ~until f state =
  let rec loop s =
    if until s then ()
    else loop (f s)
  in loop state

(* 'results' generates the specified output starting from initial values t=0, temp=100C; ending at t=100s *)
let results fn =
  Printf.printf "\t  time\t euler\tanalytic\n%!";
  let until (t,y) =
    Printf.printf "\t%7.3f\t%7.3f\t%9.5f\n%!" t y (analytic t);
    t >= 100.
  in recur ~until fn (0.,100.)

results (cool ~step:10.)
results (cool ~step:5.)
results (cool ~step:2.)

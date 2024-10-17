(* Euler integration by recurrence relation.
 * Given a function, and stepsize, provides a function of (t,y) which
 * returns the next step: (t',y'). *)
let euler f ~step (t,y) = ( t+.step, y +. step *. f t y )

(* newton_cooling doesn't use time parameter, so _ is a placeholder *)
let newton_cooling ~k ~tr _ y = -.k *. (y -. tr)

(* analytic solution for Newton cooling *)
let analytic_solution ~k ~tr ~t0 t = tr +. (t0 -. tr) *. exp (-.k *. t)

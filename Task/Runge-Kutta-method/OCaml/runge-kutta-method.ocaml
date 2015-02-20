let y' t y = t *. sqrt y
let exact t = let u = 0.25*.t*.t +. 1.0 in u*.u

let rk4_step (y,t) h =
  let k1 = h *. y' t y in
  let k2 = h *. y' (t +. 0.5*.h) (y +. 0.5*.k1) in
  let k3 = h *. y' (t +. 0.5*.h) (y +. 0.5*.k2) in
  let k4 = h *. y' (t +. h) (y +. k3) in
  (y +. (k1+.k4)/.6.0 +. (k2+.k3)/.3.0, t +. h)

let rec loop h n (y,t) =
  if n mod 10 = 1 then
    Printf.printf "t = %f,\ty = %f,\terr = %g\n" t y (abs_float (y -. exact t));
  if n < 102 then loop h (n+1) (rk4_step (y,t) h)

let _ = loop 0.1 1 (1.0, 0.0)

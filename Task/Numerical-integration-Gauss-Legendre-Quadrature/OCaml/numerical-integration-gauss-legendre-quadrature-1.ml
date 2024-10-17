let rec leg n x = match n with (* Evaluate Legendre polynomial *)
   | 0 -> 1.0
   | 1 -> x
   | k -> let u = 1.0 -. 1.0 /. float k in
      (1.0+.u)*.x*.(leg (k-1) x) -. u*.(leg (k-2) x);;

let leg' n x = match n with (* derivative *)
   | 0 -> 0.0
   | 1 -> 1.0
   | _ -> ((leg (n-1) x) -. x*.(leg n x)) *. (float n)/.(1.0-.x*.x);;

let approx_root k n = (* Reversed Francesco Tricomi: 1 <= k <= n *)
   let pi = acos (-1.0) and s = float(2*n)
   and t = 1.0 +. float(1-4*k)/.float(4*n+2) in
   (1.0 -. (float (n-1))/.(s*.s*.s))*.cos(pi*.t);;

let rec refine r n = (* Newton-Raphson *)
   let r1 = r -. (leg n r)/.(leg' n r) in
   if abs_float (r-.r1) < 2e-16 then r1 else refine r1 n;;

let root k n = refine (approx_root k n) n;;

let node k n = (* Abscissa and weight *)
   let r = root k n in
   let deriv = leg' n r in
   let w = 2.0/.((1.0-.r*.r)*.(deriv*.deriv)) in
   (r,w);;

let nodes n =
   let rec aux k = if k > n then [] else node k n :: aux (k+1)
   in aux 1;;

let quadrature n f a b =
   let f1 x = f ((x*.(b-.a) +. a +. b)*.0.5) in
   let eval s (x,w) = s +. w*.(f1 x) in
   0.5*.(b-.a)*.(List.fold_left eval 0.0 (nodes n));;

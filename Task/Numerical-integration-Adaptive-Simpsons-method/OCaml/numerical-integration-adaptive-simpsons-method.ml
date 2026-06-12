let quad_asr f a b tol depth =
  let _quad_asr_simpsons a fa b fb =
    let m = 0.5 *. (a +. b) in
    let fm = f m in
    let h = b -. a in
    (m, fm, (h /. 6.0) *. (fa +. (4.0 *. fm) +. fb))
  in
  let rec _quad_asr a fa b fb tol whole m fm depth =
    let (lm, flm, left) = _quad_asr_simpsons a fa m fm in
    let (rm, frm, right) = _quad_asr_simpsons m fm b fb in
    let delta = left +. right -. whole in
    let tol_ = 0.5 *. tol in
    if depth <= 0 || tol_ = tol || Float.abs delta <= 15.0 *. tol then
      left +. right +. (delta /. 15.0)
    else
      _quad_asr a fa m fm tol_ left lm flm (depth - 1)
      +. _quad_asr m fm b fb tol_ right rm frm (depth - 1)
  in
  let fa = f a and fb = f b in
  let (m, fm, whole) = _quad_asr_simpsons a fa b fb in
  _quad_asr a fa b fb tol whole m fm depth
;;

print_string
  "estimated definite integral of sin(x) for x from 0 to 1: ";
print_float (quad_asr sin 0.0 1.0 1.0e-9 1000);
print_newline ()
;;

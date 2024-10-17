type quadroots =
  | RealRoots of float * float
  | ComplexRoots of Complex.t * Complex.t ;;

let quadsolve a b c =
  let d = (b *. b) -. (4.0 *. a *. c) in
  if d < 0.0
  then
    let r = -. b /. (2.0 *. a)
    and i = sqrt(-. d) /. (2.0 *. a) in
    ComplexRoots ({ Complex.re = r; Complex.im = i },
                  { Complex.re = r; Complex.im = (-.i) })
  else
    let r =
      if b < 0.0
      then ((sqrt d) -. b) /. (2.0 *. a)
      else ((sqrt d) +. b) /. (-2.0 *. a)
    in
    RealRoots (r, c /. (r *. a))
;;

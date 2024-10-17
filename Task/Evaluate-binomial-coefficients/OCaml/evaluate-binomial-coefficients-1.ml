let binomialCoeff n p =
  let p = if p < n -. p then p else n -. p in
  let rec cm res num denum =
    (* this method partially prevents overflow.
     * float type is choosen to have increased domain on 32-bits computer,
     * however algorithm ensures an integral result as long as it is possible
     *)
    if denum <= p then cm ((res *. num) /. denum) (num -. 1.) (denum +. 1.)
    else res in
  cm 1. n 1.

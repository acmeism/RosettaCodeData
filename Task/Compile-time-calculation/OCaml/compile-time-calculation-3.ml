let fact10 =
  let rec factorial n =
   if n = 1 then n else n * factorial (n-1)
  in
  (factorial[@unrolled 10]) 10

(* The unrolled annotation is what allows flambda to keep reducing the call
 * Beware that the number of unrollings must be greater than or equal to the
 * number of iterations (recursive calls) for this to compile down to a constant. *)

fun dot (v, u) = (
  if Vector.length v <> Vector.length u then
    raise ListPair.UnequalLengths
  else ();
  Vector.foldli (fn (i, v_i, z) => v_i * Vector.sub (u, i) + z) 0.0 v
  )

(*
- dot (#[1.0, 3.0, ~5.0], #[4.0, ~2.0, ~1.0]);
val it = 3.0 : real
*)

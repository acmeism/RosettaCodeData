(* Assuming real type for coefficients and x *)
fun horner coeffList x = foldr (fn (a, b) => a + b * x) (0.0) coeffList

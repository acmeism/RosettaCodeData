datatype color = R | B
datatype 'a tree = E | T of color * 'a tree * 'a * 'a tree

(** val balance = fn : color * 'a tree * 'a * 'a tree -> 'a tree *)
fun balance (B, T (R, T (R,a,x,b), y, c), z, d) = T (R, T (B,a,x,b), y, T (B,c,z,d))
  | balance (B, T (R, a, x, T (R,b,y,c)), z, d) = T (R, T (B,a,x,b), y, T (B,c,z,d))
  | balance (B, a, x, T (R, T (R,b,y,c), z, d)) = T (R, T (B,a,x,b), y, T (B,c,z,d))
  | balance (B, a, x, T (R, b, y, T (R,c,z,d))) = T (R, T (B,a,x,b), y, T (B,c,z,d))
  | balance (col, a, x, b)                      = T (col, a, x, b)

(** val insert = fn : int -> int tree -> int tree *)
fun insert x s = let
  fun ins E                    = T (R,E,x,E)
    | ins (s as T (col,a,y,b)) =
	if x < y then
	  balance (col, ins a, y, b)
	else if x > y then
	  balance (col, a, y, ins b)
	else
	  s
  val T (_,a,y,b) = ins s
in
  T (B,a,y,b)
end

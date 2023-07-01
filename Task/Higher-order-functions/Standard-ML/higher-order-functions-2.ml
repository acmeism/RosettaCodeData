- fun func f = f (1, 2);
val func = fn : (int * int -> 'a) -> 'a

- print (Int.toString (func (fn (x, y) => x + y)) ^ "\n");
3
val it = () : unit

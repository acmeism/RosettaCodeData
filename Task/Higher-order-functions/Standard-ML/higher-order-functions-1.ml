- fun func1 f = f "a string";
val func1 = fn : (string -> 'a) -> 'a
- fun func2 s = "func2 called with " ^ s;
val func2 = fn : string -> string

- print (func1 func2 ^ "\n");
func2 called with a string
val it = () : unit

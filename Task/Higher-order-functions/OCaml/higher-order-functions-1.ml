# let func1 f = f "a string";;
val func1 : (string -> 'a) -> 'a = <fun>
# let func2 s = "func2 called with " ^ s;;
val func2 : string -> string = <fun>

# print_endline (func1 func2);;
func2 called with a string
- : unit = ()

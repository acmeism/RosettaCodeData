# let func f = f 1 2;;
val func : (int -> int -> 'a) -> 'a = <fun>

# Printf.printf "%d\n" (func (fun x y -> x + y));;
3
- : unit = ()

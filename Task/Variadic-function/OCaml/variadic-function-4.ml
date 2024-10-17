let print f = f ()
let arg value () cont = cont (Format.printf "%s\n" value)
let stop a = a

let () =
  print stop;
  print (arg "hello") (arg "there") stop;

(* use a prefix operator for arg *)
let (!) = arg

let () =
  print !"hello" !"hi" !"its" !"me" stop

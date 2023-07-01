> let compose f g x = f (g x);;

val compose : ('a -> 'b) -> ('c -> 'a) -> 'c -> 'b

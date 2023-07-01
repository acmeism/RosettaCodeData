> let twice f x = f (f x);;

val twice : ('a -> 'a) -> 'a -> 'a

> twice System.Math.Sqrt 81.0;;
val it : float = 3.0

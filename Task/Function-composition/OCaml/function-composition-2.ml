# let compose f g x = f (g x);;
val compose : ('a -> 'b) -> ('c -> 'a) -> 'c -> 'b = <fun>
# let sin_asin = compose sin asin;;
val sin_asin : float -> float = <fun>
# sin_asin 0.5;;
- : float = 0.5

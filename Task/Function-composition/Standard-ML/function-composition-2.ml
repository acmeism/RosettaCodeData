- fun compose (f, g) x = f (g x);
val compose = fn : ('a -> 'b) * ('c -> 'a) -> 'c -> 'b
- val sin_asin = compose (Math.sin, Math.asin);
val sin_asin = fn : real -> real
- sin_asin 0.5;
val it = 0.5 : real

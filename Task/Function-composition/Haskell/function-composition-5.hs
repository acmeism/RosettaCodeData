Prelude> let compose f g x = f (g x)
Prelude> let sin_asin = compose sin asin
Prelude> sin_asin 0.5
0.5

import Html exposing (text)

type Mu a b = Roll (Mu a b -> a -> b)

unroll : Mu a b -> (Mu a b -> a -> b)
unroll (Roll x) = x

fix : ((a -> b) -> (a -> b)) -> (a -> b)
fix f = let g r = f (\v -> unroll r r v)
        in g (Roll g)

fac : Int -> Int
fac = fix <|
    \f n -> if n <= 0
            then 1
            else n * f (n - 1)

main = text <| toString <| fac 5

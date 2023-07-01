import List exposing (product, range)

factorial : Int -> Int
factorial a =
    product (range 1 a)

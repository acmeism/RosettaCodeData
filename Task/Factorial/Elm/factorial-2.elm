factorialAux : Int -> Int -> Int
factorialAux a acc =
    if a < 2 then acc else factorialAux (a - 1) (a * acc)

factorial : Int -> Int
factorial a =
    factorialAux a 1

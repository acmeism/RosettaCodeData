let rec f (x : float) =
    match x with
        | 0. -> x
        | x -> (1. / (x * x)) + f (x - 1.)

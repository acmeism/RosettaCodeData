let rec fix f x = f (fix f) x

let fib = function
    | n when n < 0 -> None
    | n -> Some (fix (fun f -> (function | 0 | 1 -> 1 | n -> f (n-1) + f (n-2))) n)

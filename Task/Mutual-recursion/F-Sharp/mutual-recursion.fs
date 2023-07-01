let rec f n =
    match n with
    | 0 -> 1
    | _ -> n - (m (f (n-1)))
and m n =
    match n with
    | 0 -> 0
    | _ -> n - (f (m (n-1)))

let sieve limit =
    let p = Array.make (limit + 1) true in
        let rec sieve_outer d =
            if d * d > limit then p
            else if p.(d) then
                let rec sieve_inner m =
                    if m > limit then sieve_outer (d + 1)
                    else ((p.(m) <- false); sieve_inner (m + d))
                in sieve_inner (d * d)
            else sieve_outer (d + 1)
        in sieve_outer 2

let primes limit =
    let s = (sieve limit) in
        List.init (limit - 1) (fun i -> i + 2)
        |> List.filter (fun x -> s.(x))

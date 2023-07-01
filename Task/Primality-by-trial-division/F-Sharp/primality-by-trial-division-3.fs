let rec primes = Seq.cache(Seq.append (seq[ 2; 3; 5 ]) (Seq.unfold (fun state -> Some(state, state + 2)) 7 |> Seq.filter (fun x -> IsPrime x)))

and IsPrime number =
    let rec IsPrimeCore number current limit =
        let cprime = primes |> Seq.nth current
        if cprime >= limit then
            true
        else if number % cprime = 0 then
            false
        else
            IsPrimeCore number (current + 1) (number/cprime)

    if number = 2 then
        true
    else if number < 2 then
        false
    else
        IsPrimeCore number 0 number

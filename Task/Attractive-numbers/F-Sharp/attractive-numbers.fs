// attractive_numbers.fsx
// taken from Primality by trial division
let rec primes =
    let next_state s = Some(s, s + 2)
    Seq.cache
        (Seq.append
            (seq[ 2; 3; 5 ])
            (Seq.unfold next_state 7
            |> Seq.filter is_prime))
and is_prime number =
    let rec is_prime_core number current limit =
        let cprime = primes |> Seq.item current
        if cprime >= limit then true
        elif number % cprime = 0 then false
        else is_prime_core number (current + 1) (number/cprime)
    if number = 2 then true
    elif number < 2 then false
    else is_prime_core number 0 number

// taken from Prime decomposition task and modified to add
let count_prime_divisors n =
    let rec loop c n count =
        let p = Seq.item n primes
        if c < (p * p) then count
        elif c % p = 0 then loop (c / p) n (count + 1)
        else loop c (n + 1) count
    loop n 0 1

let is_attractive = count_prime_divisors >> is_prime
let print_iter i n =
    if i % 10 = 9
    then printfn "%d" n
    else printf "%d\t" n

[1..120]
|> List.filter is_attractive
|> List.iteri print_iter

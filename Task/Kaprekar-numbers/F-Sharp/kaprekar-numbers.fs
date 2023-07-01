// Count digits in number
let digits x =
    let rec digits' p x =
        if 10.**p > x then p else digits' (p + 1.) x
    digits' 1. x


// Is n a Kaprekar number?
let isKaprekar n =
    // Reference: http://oeis.org/A006886
    // Positive numbers n such that n=q+r
    // And n^2=q*10^m+r,
    //  for some m >= 1,
    //  q>=0 and 0<=r<10^m,
    //  with n != 10^a, a>=1.
    let nSquared = n * n
    let a = float((digits n) - 1.)

    // Create a list of tuples from the nSquared digit splits
    [1. .. float (digits nSquared)]
    |> List.map (fun e ->
        // Splits the nSquared digits into 2 parts
        let x = 10.**e
        let q = float(int(Math.Floor (nSquared / x)))
        let r = nSquared - (q * x)
        (q, r))
    // Filter results based on rules
    |> List.exists (fun (q, r) ->
        q + r = n &&
        if a >= 1. then n % 10.**a <> 0. else true)


// List Kaprekar numbers from 1 to 10,000
[1 .. 10000]
|> List.filter (float >> isKaprekar)

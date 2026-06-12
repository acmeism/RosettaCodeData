open System

let iroot (base_ : bigint) n =
    if base_ < bigint.Zero || n <= 0 then
        raise (ArgumentException "Bad parameter")

    let n1 = n - 1
    let n2 = bigint n
    let n3 = bigint n1
    let mutable c = bigint.One
    let mutable d = (n3 + base_) / n2
    let mutable e = ((n3 * d) + (base_ / bigint.Pow(d, n1))) / n2
    while c <> d && c <> e do
        c <- d
        d <- e
        e <- (n3 * e + base_ / bigint.Pow(e, n1)) / n2

    if d < e then
        d
    else
        e

[<EntryPoint>]
let main _ =
    Console.WriteLine("3rd integer root of 8 = {0}", (iroot (bigint 8) 3))
    Console.WriteLine("3rd integer root of 9 = {0}", (iroot (bigint 9) 3))

    let b = bigint.Pow(bigint 100, 2000) * (bigint 2)
    Console.WriteLine("First 2001 digits of the sqaure root of 2: {0}", (iroot b 2))

    0 // return an integer exit code

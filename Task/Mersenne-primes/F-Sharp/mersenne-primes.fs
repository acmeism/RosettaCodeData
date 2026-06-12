open System
open System.Numerics

let Sqrt (n:BigInteger) =
    if n < (BigInteger 0) then raise (ArgumentException "Negative argument.")
    if n < (BigInteger 2) then n
    else
        let rec H v r s =
            if v < s then
                r
            else
                H (v - s) (r + (BigInteger 1)) (s + (BigInteger 2))
        H n (BigInteger 0) (BigInteger 1)

let IsPrime (n:BigInteger) =
    if n < (BigInteger 2) then false
    elif n % (BigInteger 2) = (BigInteger 0) then n = (BigInteger 2)
    elif n % (BigInteger 3) = (BigInteger 0) then n = (BigInteger 3)
    elif n % (BigInteger 5) = (BigInteger 0) then n = (BigInteger 5)
    elif n % (BigInteger 7) = (BigInteger 0) then n = (BigInteger 7)
    elif n % (BigInteger 11) = (BigInteger 0) then n = (BigInteger 11)
    elif n % (BigInteger 13) = (BigInteger 0) then n = (BigInteger 13)
    elif n % (BigInteger 17) = (BigInteger 0) then n = (BigInteger 17)
    elif n % (BigInteger 19) = (BigInteger 0) then n = (BigInteger 19)
    else
        let limit = (Sqrt n)
        let rec H t =
            if t <= limit then
                if n % t = (BigInteger 0) then false
                else
                    let t2 = t + (BigInteger 2)
                    if n % t2 = (BigInteger 0) then false
                    else H (t2 + (BigInteger 4))
            else
                true
        H (BigInteger 23)

[<EntryPoint>]
let main _ =
    let MAX = BigInteger 9

    let rec loop (pow:int) (count:int) =
        if IsPrime (BigInteger pow) then
            let p = BigInteger.Pow((BigInteger 2), pow) - (BigInteger 1)
            if IsPrime p then
                printfn "2 ^ %A - 1" pow
                if (BigInteger (count + 1)) >= MAX then count
                else loop (pow + 1) (count + 1)
            else loop (pow + 1) count
        else loop (pow + 1) count

    loop 2 0 |> ignore

    0 // return an integer exit code

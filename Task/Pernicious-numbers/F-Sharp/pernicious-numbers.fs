open System

//Taken from https://gist.github.com/rmunn/bc49d32a586cdfa5bcab1c3e7b45d7ac
let bitcount (n : int) =
    let count2 = n - ((n >>> 1) &&& 0x55555555)
    let count4 = (count2 &&& 0x33333333) + ((count2 >>> 2) &&& 0x33333333)
    let count8 = (count4 + (count4 >>> 4)) &&& 0x0f0f0f0f
    (count8 * 0x01010101) >>> 24

//Modified from other examples to actually state the 1 is not prime
let isPrime n =
    if n < 2 then
        false
    else
        let sqrtn n = int <| sqrt (float n)
        seq { 2 .. sqrtn n } |> Seq.exists(fun i -> n % i = 0) |> not

[<EntryPoint>]
let main _ =
    [1 .. 100] |> Seq.filter (bitcount >> isPrime) |> Seq.take 25 |> Seq.toList |> printfn "%A"
    [888888877 .. 888888888] |> Seq.filter (bitcount >> isPrime) |> Seq.toList |> printfn "%A"
    0 // return an integer exit code

open System

let random = Random()

let randN = random.Next >> (=)0 >> Convert.ToInt32

let rec unbiased n =
    let a = randN n
    if a <> randN n then a else unbiased n

[<EntryPoint>]
let main argv =
    let n = if argv.Length > 0 then UInt32.Parse(argv.[0]) |> int else 100000
    for b = 3 to 6 do
        let cb = ref 0
        let cu = ref 0
        for i = 1 to n do
            cb := !cb + randN b
            cu := !cu + unbiased b
        printfn "%d: %5.2f%%  %5.2f%%"
            b (100. * float !cb / float n) (100. * float !cu / float n)
    0

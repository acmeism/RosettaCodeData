open System

let leo l0 l1 d =
    Seq.unfold (fun (x, y) -> Some (x, (y, x + y + d))) (l0, l1)

let leonardo = leo 1 1 1
let fibonacci = leo 0 1 0

[<EntryPoint>]
let main _ =
    let leoNums = Seq.take 25 leonardo |> Seq.chunkBySize 16
    printfn "First 25 of the (1, 1, 1) Leonardo numbers:\n%A" leoNums
    Console.WriteLine()

    let fibNums = Seq.take 25 fibonacci |> Seq.chunkBySize 16
    printfn "First 25 of the (0, 1, 0) Leonardo numbers (= Fibonacci number):\n%A" fibNums

    0 // return an integer exit code

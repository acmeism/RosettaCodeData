open System

[<EntryPoint>]
let main args =
    let rnd = new Random()

    let one_of_n n =
        let rec loop i r =
            if i >= n then r else
                if rnd.Next(i + 1) = 0
                then loop (i + 1) i
                else loop (i + 1) r
        loop 1 0

    let test n trials =
        let ar = Array.zeroCreate n
        for i = 1 to trials do
            let d = one_of_n n
            ar.[d] <- 1 + ar.[d]
        Console.WriteLine (String.Join(" ", ar))

    test 10 1000000
    0

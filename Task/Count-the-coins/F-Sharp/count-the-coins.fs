let changes amount coins =
    let ways = Array.zeroCreate (amount + 1)
    ways.[0] <- 1L
    List.iter (fun coin ->
        for j = coin to amount do ways.[j] <- ways.[j] + ways.[j - coin]
    ) coins
    ways.[amount]

[<EntryPoint>]
let main argv =
    printfn "%d" (changes    100 [25; 10; 5; 1]);
    printfn "%d" (changes 100000 [100; 50; 25; 10; 5; 1]);
    0

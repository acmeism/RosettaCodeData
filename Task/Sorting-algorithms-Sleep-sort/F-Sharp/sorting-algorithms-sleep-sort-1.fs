let sleepSort (values: seq<int>) =
    values
    |> Seq.map (fun x -> async {
        do! Async.Sleep x
        Console.WriteLine x
    })
    |> Async.Parallel
    |> Async.Ignore
    |> Async.RunSynchronously

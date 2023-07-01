let KnuthShuffle (lst : array<'a>) =                   // '
    let Swap i j =                                                  // Standard swap
        let item = lst.[i]
        lst.[i] <- lst.[j]
        lst.[j] <- item
    let rnd = new Random()
    let ln = lst.Length
    [0..(ln - 2)]                                                   // For all indices except the last
    |> Seq.iter (fun i -> Swap i (rnd.Next(i, ln)))                 // swap th item at the index with a random one following it (or itself)
    lst                                                             // Return the list shuffled in place

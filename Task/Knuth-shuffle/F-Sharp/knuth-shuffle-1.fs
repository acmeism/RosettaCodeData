open System

let FisherYatesShuffle (initialList : array<'a>) =                  // '
    let availableFlags = Array.init initialList.Length (fun i -> (i, true))
                                                                    // Which items are available and their indices
    let rnd = new Random()
    let nextItem nLeft =
        let nItem = rnd.Next(0, nLeft)                              // Index out of available items
        let index =                                                 // Index in original deck
            availableFlags                                          // Go through available array
            |> Seq.filter (fun (ndx,f) -> f)                        // and pick out only the available tuples
            |> Seq.nth nItem                                        // Get the one at our chosen index
            |> fst                                                  // and retrieve it's index into the original array
        availableFlags.[index] <- (index, false)                    // Mark that index as unavailable
        initialList.[index]                                         // and return the original item
    seq {(initialList.Length) .. -1 .. 1}                           // Going from the length of the list down to 1
    |> Seq.map (fun i -> nextItem i)                                // yield the next item

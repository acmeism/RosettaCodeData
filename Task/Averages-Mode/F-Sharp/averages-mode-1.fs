let mode (l:'a seq) =
    l
    |> Seq.countBy (fun item -> item)               // Count individual items
    |> Seq.fold                                     // Find max counts
        (fun (cp, lst) (item, c) ->                 // State is (count, list of items with that count)
            if c > cp then (c, [item])              // New max - keep count and a list of the single item
            elif c = cp then (c, item :: lst)       // New element with max count - prepend it to the list
            else (cp,lst))                          // else just keep old count/list
        (0, [Unchecked.defaultof<'a>])              // Start with a count of 0 and a dummy item
    |> snd                                          // From (count, list) we just want the second item (the list)

[<EntryPoint>]
let main args =
    // Create some sets (of int):
    let s1 = Set.ofList [1;2;3;4;3]
    let s2 = Set.ofArray [|3;4;5;6|]

    printfn "Some sets (of int):"
    printfn "s1 = %A" s1
    printfn "s2 = %A" s2
    printfn "Set operations:"
    printfn "2 ∈ s1? %A" (s1.Contains 2)
    printfn "10 ∈ s1? %A" (s1.Contains 10)
    printfn "s1 ∪ s2 = %A" (Set.union s1 s2)
    printfn "s1 ∩ s2 = %A" (Set.intersect s1 s2)
    printfn "s1 ∖ s2 = %A" (Set.difference s1 s2)
    printfn "s1 ⊆ s2? %A" (Set.isSubset s1 s1)
    printfn "{3, 1} ⊆ s1? %A" (Set.isSubset (Set.ofList [3;1]) s1)
    printfn "{3, 2, 4, 1} = s1? %A" ((Set.ofList [3;2;4;1]) = s1)
    printfn "s1 = s2? %A" (s1 = s2)
    printfn "More set operations:"
    printfn "#s1 = %A" s1.Count
    printfn "s1 ∪ {99} = %A" (s1.Add 99)
    printfn "s1 ∖ {3} = %A" (s1.Remove 3)
    printfn "s1 ⊂ s1? %A" (Set.isProperSubset s1 s1)
    printfn "s1 ⊂ s2? %A" (Set.isProperSubset s1 s2)
    0

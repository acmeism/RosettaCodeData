open System

let levenshtein (s1:string) (s2:string) : int =

    let s1' = s1.ToCharArray()
    let s2' = s2.ToCharArray()

    let rec dist l1 l2 =
        match (l1,l2) with
        | (l1, 0) -> l1
        | (0, l2) -> l2
        | (l1, l2) ->
            if s1'.[l1-1] = s2'.[l2-1] then dist (l1-1) (l2-1)
            else
                let d1 = dist (l1 - 1) l2
                let d2 = dist l1 (l2 - 1)
                let d3 = dist (l1 - 1) (l2 - 1)
                1 + Math.Min(d1,(Math.Min(d2,d3)))

    dist s1.Length s2.Length

printfn "dist(kitten, sitting) = %i" (levenshtein "kitten" "sitting")

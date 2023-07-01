let rec qsort = function
    hd :: tl ->
        let less, greater = List.partition ((>=) hd) tl
        List.concat [qsort less; [hd]; qsort greater]
    | _ -> []

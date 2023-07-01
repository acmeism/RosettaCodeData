let maxsubseq s =
    let (_, _, maxsum, maxseq) =
        List.fold (fun (sum, seq, maxsum, maxseq) x ->
            let (sum, seq) = (sum + x, x :: seq)
            if sum < 0 then (0, [], maxsum, maxseq)
            else if sum > maxsum then (sum, seq, sum, seq)
            else (sum, seq, maxsum, maxseq))
            (0, [], 0, []) s
    List.rev maxseq

printfn "%A" (maxsubseq  [-1 ; -2 ; 3 ; 5 ; 6 ; -2 ; -1 ; 4; -4 ; 2 ; -1])

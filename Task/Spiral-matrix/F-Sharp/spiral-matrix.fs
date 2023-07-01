let Spiral n =
    let sq = Array2D.create n n 0                                   // Set up an output array
    let nCur = ref -1                                               // Current value being inserted
    let NextN() = nCur := (!nCur+1) ; !nCur                         // Inc current value and return new value
    let Frame inset =                                               // Create the "frame" at an offset from the outside
        let rangeF = [inset..(n - inset - 2)]                       // Range we use going forward
        let rangeR = [(n - inset - 1)..(-1)..(inset + 1)]           // Range we use going backward
        rangeF |> Seq.iter (fun i -> sq.[inset,i] <- NextN())       // Top of frame
        rangeF |> Seq.iter (fun i -> sq.[i,n-inset-1] <- NextN())   // Right side of frame
        rangeR |> Seq.iter (fun i -> sq.[n-inset-1,i] <- NextN())   // Bottom of frame
        rangeR |> Seq.iter (fun i -> sq.[i,inset] <- NextN())       // Left side of frame
    [0..(n/2 - 1)] |> Seq.iter (fun i -> Frame i)                   // Fill in all frames
    if n &&& 1 = 1 then sq.[n/2,n/2] <- n*n - 1                     // If n is odd, fill in the last single value
    sq                                                              // Return our output array

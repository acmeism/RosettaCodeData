let extractRanges = function
  | []    -> Seq.empty
  | x::xr ->
      let rec loop ys first last = seq {
        match ys with
        | y::yr when y = last + 1 -> yield! loop yr first y  // add to current range
        | y::yr                   -> yield (first, last)     // finish current range
                                     yield! loop yr y y      //  and start next
        | []                      -> yield (first, last) }   // finish final range
      loop xr x x


let rangeToString (s,e) =
  match e-s with
  | 0 -> sprintf "%d" s
  | 1 -> sprintf "%d,%d" s e
  | _ -> sprintf "%d-%d" s e


let extract = extractRanges >> Seq.map rangeToString >> String.concat ","


printfn "%s" (extract [ 0; 1; 2; 4; 6; 7; 8; 11; 12; 14; 15; 16; 17; 18; 19; 20; 21;
                        22; 23; 24; 25; 27; 28; 29; 30; 31; 32; 33; 35; 36; 37; 38; 39 ])

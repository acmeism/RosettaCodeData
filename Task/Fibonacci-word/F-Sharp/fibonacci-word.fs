// include the code from /wiki/Entropy#F.23 for the entropy function

let fiboword  =
    Seq.unfold
        (fun (state : string * string) ->
            Some (fst state, (snd state, (snd state) + (fst state)))) ("1", "0")

printfn "%3s %10s %10s %s" "#" "Length" "Entropy" "Word (if length < 40)"
Seq.iteri (fun i (s : string) ->
    printfn "%3i %10i %10.7g %s" (i+1) s.Length (entropy s) (if s.Length < 40 then s else ""))
    (Seq.take 37 fiboword)

// Determine if a string has all the same characters. Nigel Galloway: June 9th., 2020
let fN n=if String.length n=0 then None else n.ToCharArray()|>Array.tryFindIndex(fun g->g<>n.[0])

let allSame n=match fN n with
               Some g->printfn "First different character in <<<%s>>> (length %d) is hex %x at position %d" n n.Length (int n.[g]) g
              |_->printfn "All Characters are the same in <<<%s>>> (length %d)" n n.Length


allSame ""
allSame "   "
allSame "2"
allSame "333"
allSame ".55"
allSame "tttTTT"
allSame "4444 444k"

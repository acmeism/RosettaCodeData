//Be boggled? Nigel Galloway: September 19th., 2018
let N=System.Random()
let fN=List.unfold(function |(0,0)->None |(n,g)->let ng=N.Next (n+g) in Some (if ng>=n then ("Black",(n,g-1)) else ("Red",(n-1,g))))(26,26)
let fG n=let (n,n')::(g,g')::_=List.countBy(fun (n::g::_)->if n=g then n else g) n in sprintf "%d %s cards and %d %s cards" n' n g' g
printf "A well shuffled deck -> "; List.iter (printf "%s ") fN; printfn ""
fN |> List.chunkBySize 2 |> List.groupBy List.head |> List.iter(fun(n,n')->printfn "The %s pile contains %s" n (fG n'))

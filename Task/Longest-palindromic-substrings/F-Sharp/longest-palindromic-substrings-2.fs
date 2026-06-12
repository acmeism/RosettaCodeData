let fN g=if g=[||] then (0,0) else g|>Array.mapi(fun n g->(n,g))|>Array.maxBy snd
let lpss s=let n,g=Manacher s in let n,g=fN n,fN g in if (snd n)*2+1>(snd g)*2 then s.[(fst n)-(snd n)..(fst n)+(snd n)] else s.[(fst g)-(snd g)+1..(fst g)+(snd g)]
let test = ["three old rotators"; "never reverse"; "stable was I ere I saw elbatrosses"; "abracadabra"; "drome"; "the abbatial palace"; ""]
test|>List.iter(fun n->printfn "A longest palindromic substring of \"%s\" is \"%s\"" n (lpss n))

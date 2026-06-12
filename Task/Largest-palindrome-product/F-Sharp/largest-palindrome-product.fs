// Largest palindrome product. Nigel Galloway: November 3rd., 2021
let fN g=let rec fN g=[yield g%10; if g>=10 then yield! fN(g/10)] in let n=fN g in n=List.rev n
printfn "%d" ([for n in 100..999 do for g in n..999->n*g]|>List.filter fN|>List.max)

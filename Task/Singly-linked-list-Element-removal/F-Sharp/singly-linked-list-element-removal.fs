// Singly-linked list/Element removal. Nigel Galloway: March 22nd., 2022
let N=[23;42;1;13;0]
let fG n g=List.indexed n|>List.filter(fun(n,_)->n<>g)|>List.map snd
printfn "   before: %A\nand after: %A" N (fG N 2)

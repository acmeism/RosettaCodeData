// List division. Nigel Galloway: April 1st., 2026
let fG n g=if List.length n<g then failwith "Why" else n|>List.splitInto g
printfn "%A\n%A\n%A" (fG [1..7] 3) (fG [1..7] 6) (fG [1..7] 7) //(fG [1..7] 8)

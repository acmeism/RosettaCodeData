let rec nextrow l =
    match l with
    | []      -> []
    | h :: [] -> [1]
    | h :: t  -> h + t.Head :: nextrow t

let pascalTri n = List.scan(fun l i -> 1 :: nextrow l) [1] [1 .. n]

for row in pascalTri(10) do
    for i in row do
        printf "%s" (i.ToString() + ", ")
    printfn "%s" "\n"

let fW=Map[((1,3),-2);((3,4),2);((4,2),-1);((2,1),4);((2,3),3)]
let N,G=Floyd [|1..4|] fW
List.allPairs [1..4] [1..4]|>List.filter(fun (n,g)->n<>g)|>List.iter(fun (n,g)->printfn "%d->%d %d %A" n g N.[(n,g)] (n::(List.ofSeq (G n g))))

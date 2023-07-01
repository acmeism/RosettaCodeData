// Motzkin numbers. Nigel Galloway: September 10th., 2021
let M=let rec fN g=seq{yield List.item 1 g; yield! fN(0L::(g|>List.windowed 3|>List.map(List.sum))@[0L;0L])} in fN [0L;1L;0L;0L]
M|>Seq.take 42|>Seq.iter(printfn "%d")

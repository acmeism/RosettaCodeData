// Loops/With multiple ranges. Nigel Galloway: June 13th., 2022
let x,y,z,one,three,seven=5,-5,-2,1,3,7
let Range=[-three..three..pown 3 3]@[-7..x..seven]@[555..550-y]@[22..-three.. -28]@[1927..1939]@[x..z..y]@[pown 11 x..(pown 11 x)+1]
printfn "Sum=%d Product=%d" (Range|>Seq.sumBy(abs)) (Range|>Seq.filter((<>)0)|>Seq.fold(fun n g->if abs n<pown 2 27 then n*g else n) 1)

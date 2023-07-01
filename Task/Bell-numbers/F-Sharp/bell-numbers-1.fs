// Generate bell triangle. Nigel Galloway: July 6th., 2019
let bell=Seq.unfold(fun g->Some(g,List.scan(+) (List.last g) g))[1I]

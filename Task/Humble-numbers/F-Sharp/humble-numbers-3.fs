for n in [1..18] do let g=pown 10UL n in printfn "There are %d humble numbers with %d digits" (humble|>Seq.skipWhile(fun n->n<g/10UL)|>Seq.takeWhile(fun n->n<g)|>Seq.length) n

[1..2..200]|>Seq.filter(fun n->isPrime(2+pown n 3))|>Seq.iter(fun n->printfn "n=%3d -> %d" n (2+pown n 3))

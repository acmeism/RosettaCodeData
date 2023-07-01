// Sleeping Beauty: Nigel Galloway. May 16th., 2021
let heads,woken=let n=System.Random() in {1..1000}|>Seq.fold(fun(h,w) g->match n.Next(2) with 0->(h+1,w+1) |_->(h,w+2))(0,0)
printfn "During 1000 tosses Sleeping Beauty woke %d times, %d times the toss was heads. %.0f%% of times heads had been tossed when she awoke" woken heads (100.0*float(heads)/float(woken))

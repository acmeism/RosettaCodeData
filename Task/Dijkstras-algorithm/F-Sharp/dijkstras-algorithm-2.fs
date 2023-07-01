type Node= |A|B|C|D|E|F
let G=Map[((A,B),7);((A,C),9);((A,F),14);((B,C),10);((B,D),15);((C,D),11);((C,F),2);((D,E),6);((E,F),9)]
let paths=Dijkstra [B;C;D;E;F] G A
printfn "%A" (paths E)
printfn "%A" (paths F)

// Bifid cipher. Nigel Galloway: September 17th., 2024
let polybius alphabet n g=let ng=Seq.allPairs [1..n] [1..g] in (Seq.zip ng alphabet|>Map.ofSeq,Seq.zip alphabet ng|>Map.ofSeq)
let fN (i,g) (e:Map<(int*int),char>)=i@g|>List.chunkBySize 2|>List.map(fun n->e[(n[0],n[1])])|>Array.ofList|>System.String
let fG (n:Map<char,int*int>) g=g|>Seq.map(fun g->n[g])|>List.ofSeq|>List.unzip
let encrypt (n:Map<(int * int),char>,g:Map<char,(int * int)>) text=fN (fG g text) n
let decrypt (n:Map<(int * int),char>,g:Map<char,(int * int)>) text=
  let p,q=let p,q=fG g text in List.map2(fun p q->[p;q]) p q|>List.concat|>List.splitAt p.Length
  List.zip p q |>List.map(fun g->n[g])|>Array.ofList|>System.String

let p1=polybius "abcdefghiklmnopqrstuvwxyz" 5 5
let s="attackatdawn" in let e=encrypt p1 s in printfn $"%s{s} -> %s{e} -> %s{decrypt p1 e}"
let s="fleeatonce" in let e=encrypt p1 s in printfn $"%s{s} -> %s{e} -> %s{decrypt p1 e}"
let p2=polybius "bgwkzqpndsioaxefclumthyvr" 5 5
let s="attackatdawn" in let e=encrypt p2 s in printfn $"%s{s} -> %s{e} -> %s{decrypt p2 e}"
let s="fleeatonce" in let e=encrypt p2 s in printfn $"%s{s} -> %s{e} -> %s{decrypt p2 e}"
let p3=polybius "abcdefghijklmnopqrstuvwxyz0123456789" 6 6
let s="theinvasionwillstarton1january2025" in let e=encrypt p3 s in printfn $"%s{s} -> %s{e} -> %s{decrypt p3 e}"

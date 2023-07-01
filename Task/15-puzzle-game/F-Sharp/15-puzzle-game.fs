// 15 Puzzle Game. Nigel Galloway: August 9th., 2020
let Nr,Nc,RA,rnd=[|3;0;0;0;0;1;1;1;1;2;2;2;2;3;3;3|],[|3;0;1;2;3;0;1;2;3;0;1;2;3;0;1;2|],[|for n in [1..16]->n%16|],System.Random()
let rec fN g Σ=function h::t->fN g (Σ+List.sumBy(fun n->if h>n then 1 else 0)t) t|_->(Σ-g/4)%2=1
let rec fI g=match if System.Console.IsInputRedirected then char(System.Console.Read()) else System.Console.ReadKey(true).KeyChar with
               n when Seq.contains n g->printf "%c" n; (match n with 'l'-> -1|'r'->1|'d'->4|_-> -4)|_->System.Console.Beep(); fI g
let rec fG n Σ=function 0->(List.findIndex((=)0)Σ,Σ)|g->let i=List.item(rnd.Next(g)) n in fG(List.except [i] n)(i::Σ)(g-1)
let rec fE()=let n,g=fG [0..15] [] 16 in if fN n 0 (List.except [0] g) then (n,Array.ofList g) else fE()
let rec fL(n,g) Σ=let fa=printfn "";Array.chunkBySize 4 g|>Array.iter(fun n->Array.iter(printf "%3d")n;printfn "")
                  match g=RA with true->printfn "Solved in %d moves" Σ; fa; 0
                                 |_->let vM=match n/4,n%4 with (0,0)->"rd"|(0,3)->"ld"|(0,_)->"lrd"|(3,0)->"ru"|(3,3)->"lu"|(3,_)->"lru"|(_,0)->"rud"|(_,3)->"lud"|_->"lrud"
                                     fa; printf "Move Number: %2d; Manhatten Distance: %2d; Choose move from %4s: " Σ
                                         ([0..15]|>List.sumBy(fun n->match g.[n] with 0->0 |i->(abs(n/4-Nr.[i]))+(abs(n%4-Nc.[i])))) vM
                                     let v=fI vM in g.[n]<-g.[n+v];g.[n+v]<-0;fL(n+v,g)(Σ+1)
[<EntryPoint>]
let main n = fL(match n with [|n|]->let g=[|let g=uint64 n in for n in 60..-4..0->int((g>>>n)&&&15UL)|] in (Array.findIndex((=)0)g,g) |_->fE()) 0

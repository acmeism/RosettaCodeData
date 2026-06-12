// Minimum knights to attack all squares not occupied on an NxN chess board. Nigel Galloway: May 12th., 2022
type att={n:uint64; g:uint64}
         static member att n g=let g=g|>Seq.fold(fun n g->n ||| (1UL<<<g)) 0UL in {n=n|>Seq.fold(fun n g->n ||| (1UL<<<g)) 0UL; g=g}
         static member (+) (n,g)=let x=n.g ||| g.g in {n=n.n ||| g.n; g=x}
let     fN g=let fG n g=[n-g-g-1;n-g-g+1;n-g+2;n-g-2;n+g+g-1;n+g+g+1;n+g-2;n+g+2]|>List.filter(fun x->0<=x && x<g*g && abs(x%g-n%g)+abs(x/g-n/g)=3)|>List.distinct|>List.map(fun n->n/2)
             let n,g=Array.init(g*g)(fun n->att.att [n/2] (fG n g)), Array.init(g*g)(fun n->att.att (fG n g) [n/2]) in (fun g->n.[g]),(fun n->g.[n])
type cand={att:att; n:int; g:int}
type Solver={n:cand seq; i:int[]; g:(int -> att) * (int -> att); e:att; l:int[]}
            member this.test()=let rec test n i g e l=match g with 0UL->(if i=this.e then Some(n,e) else None)|g when g%2UL=1UL->test n (i+((snd this.g)(this.i.[l])))(g/2UL)(e+1)(l+1) |_->test n i (g/2UL) e (l+1)
                               let n=this.n|>Seq.choose(fun n->test n n.att (this.e.g^^^n.att.g) 0 0) in if Seq.isEmpty n then None else Some(n|>Seq.minBy snd)
            member this.xP()  ={this with n=this.n|>Seq.collect(fun n->[for g in n.n..n.g do let att=n.att+((fst this.g)(this.l.[g])) in yield {n with att=att; n=g}])}
let rec slvK (n:Solver) i g l = match n.test() with Some(r,ta)->match min l (g+ta) with t when t>2*(g+1) || l<t->slvK (n.xP()) (if t<l then Some(r,ta) else i) (g+1) (min t l) |t->Some(min t l,r)
                                                   |_->slvK (n.xP()) i (g+1) l
let tC bw s (att:att)=let n=Array2D.init s s (fun n g->if (n+g)%2=bw then (if att.n &&& pown 2UL ((n*s+g)/2) > 0UL then "X" else ".") else (if att.g &&& pown 2UL ((n*s+g)/2) > 0UL then "~" else "o"))
                      for g in 0..s-1 do n.[g,0..s-1]|>Seq.iter(fun g->printf "%s" g); printfn ""
let solveK g=printfn "\nSolving for %dx%d board" g g
             let bs,ws=[|for n in g..g+g..(g*g-1)/2 do for z in 0..g+1..(g*g-1)/2-n->((n+z)/g,(n+z)%g)|],[|for n in 0..g+g..(g*g-1)/2 do for z in 0..g+1..(g*g-1)/2-n->((n+z)/g,(n+z)%g)|]
             let i,l=let n,i=[|for n in 0..g-1 do for g in 0..g-1->(n,g)|]|>Array.partition(fun(n,g)->(n+g)%2=1) in n|>Array.map(fun(n,i)->n*g+i), i|>Array.map(fun(n,i)->n*g+i)
             let t,f=System.DateTime.UtcNow,fN g
             let bK={l=Array.concat[bs|>Array.map(fun(n,i)->n*g+i);i]|>Array.distinct; i=l; e=att.att [0..i.Length-1] [0..l.Length-1]; n=bs|>Array.mapi(fun l (n,e)->let att=((fst f)(n*g+e)) in {att=att; n=l+1; g=i.Length-1}); g=fN g}
             let wK={l=Array.concat[ws|>Array.map(fun(n,i)->n*g+i);l]|>Array.distinct; i=i; e=att.att [0..l.Length-1] [0..i.Length-1]; n=ws|>Array.mapi(fun i (n,e)->let att=((fst f)(n*g+e)) in {att=att; n=i+1; g=l.Length-1}); g=fN g}
             let (rn,rb),tc=match g with 1|2->(slvK wK None 1 (g*g/2+g%2)).Value, tC 0 g
                                       |x when x%2=0->(slvK bK None 1 (g*g/2)).Value, tC 1 g
                                       |_->let x,y=(slvK bK None 1 (g*g/2)).Value, (slvK wK None 1 (g*g/2+1)).Value in if (fst x)<(fst y) then x,tC 1 g else y,tC 0 g
             printfn "Solution found using %d knights in %A:" rn (System.DateTime.UtcNow-t); tc rb.att
for n in 1..10 do solveK n

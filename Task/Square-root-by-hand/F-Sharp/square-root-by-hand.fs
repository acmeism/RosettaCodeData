// Square Root of n 'By Hand' (n as bigint >= 1). Nigel Galloway: October 14th., 2020
let rec fN n g=match n/100I with i when i=0I->(n%100I)::g |i->fN i ((n%100I)::g)
let     fG n g=[9I.. -1I..0I]|>Seq.map(fun g->(g,g*(20I*n+g)))|>Seq.find(fun(_,n)->n<=g)
let     fL(n,g,l)=let c,n=match n with []->(g*100I,[]) |_->((List.head n)+g*100I,List.tail n)
                  let x,y=fG l c in Some(int x,(n,c-y,l*10I+x))
let sR n g l=Seq.unfold fL (fN n [],0I,0I)|>Seq.take l|>Seq.iteri(fun i n->printf "%s%d" (if i=(g+1)/2 then "." else "") n); printfn "\n"

sR 2I 1 480; sR 1089I 2 8

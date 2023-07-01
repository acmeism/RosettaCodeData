// Find all Rare numbers with a digits. Nigel Galloway: September 18th., 2019.
let rareNums a=
  let tN=set[1L;4L;5L;6L;9L]
  let izPS g=let n=(float>>sqrt>>int64)g in n*n=g
  let n=[for n in [0..a/2-1] do yield ((pown 10L (a-n-1))-(pown 10L n))]|>List.rev
  let rec fN i g e=seq{match e with 0->yield g |e->for n in i do yield! fN [-9L..9L] (n::g) (e-1)}|>Seq.filter(fun g->let g=Seq.map2(*) n g|>Seq.sum in g>0L && izPS g)
  let rec fG n i g e l=seq{
    match l with
     h::t->for l in max 0L (0L-h)..min 9L (9L-h) do if e>1L||l=0L||tN.Contains((2L*l+h)%10L) then yield! fG (n+l*e+(l+h)*g) (i+l*g+(l+h)*e) (g/10L) (e*10L) t
    |_->if n>(pown 10L (a-1)) then for l in (if a%2=0 then [0L] else [0L..9L]) do let g=l*(pown 10L (a/2)) in if izPS (n+i+2L*g) then yield (i+g,n+g)}
  fN [0L..9L] [] (a/2) |> Seq.collect(List.rev >> fG 0L 0L (pown 10L (a-1)) 1L)

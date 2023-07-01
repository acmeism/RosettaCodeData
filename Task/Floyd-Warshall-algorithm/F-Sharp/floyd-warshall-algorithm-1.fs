//Floyd's algorithm: Nigel Galloway August 5th 2018
let Floyd (n:'a[]) (g:Map<('a*'a),int>)= //nodes graph(Map of adjacency list)
  let ix n g=Seq.init (pown g n) (fun x->List.unfold(fun (a,b)->if a=0 then None else Some(b%g,(a-1,b/g)))(n,x))
  let fN w (i,j,k)=match Map.tryFind(i,j) w,Map.tryFind(i,k) w,Map.tryFind(k,j) w with
                        |(None  ,Some j,Some k)->Some(j+k)
                        |(Some i,Some j,Some k)->if (j+k) < i then Some(j+k) else None
                        |_                     ->None
  let n,z=ix 3 (Array.length n)|>Seq.choose(fun (i::j::k::_)->if i<>j&&i<>k&&j<>k then Some(n.[i],n.[j],n.[k]) else None)
       |>Seq.fold(fun (n,n') ((i,j,k) as g)->match fN n g with |Some g->(Map.add (i,j) g n,Map.add (i,j) k n')|_->(n,n')) (g,Map.empty)
  (n,(fun x y->seq{
               let rec fN n g=seq{
                 match Map.tryFind (n,g) z with
                 |Some r->yield! fN n r; yield Some r;yield! fN r g
                 |_->yield None}
               yield! fN x y |> Seq.choose id; yield y}))

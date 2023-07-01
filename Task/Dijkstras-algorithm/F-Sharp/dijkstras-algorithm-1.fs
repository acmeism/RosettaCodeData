//Dijkstra's algorithm: Nigel Galloway, August 5th., 2018
[<CustomEquality;CustomComparison>]
type Dijkstra<'N,'G when 'G:comparison>={toN:'N;cost:Option<'G>;fromN:'N}
                                        override g.Equals n =match n with| :? Dijkstra<'N,'G> as n->n.cost=g.cost|_->false
                                        override g.GetHashCode() = hash g.cost
                                        interface System.IComparable with
                                          member n.CompareTo g =
                                            match g with
                                            | :? Dijkstra<'N,'G> as n when n.cost=None -> (-1)
                                            | :? Dijkstra<'N,'G>      when n.cost=None -> 1
                                            | :? Dijkstra<'N,'G> as g                  -> compare n.cost g.cost
                                            | _-> invalidArg "n" "expecting type Dijkstra<'N,'G>"
let inline Dijkstra N G y =
  let rec fN l f=
    if List.isEmpty l then f
    else let n=List.min l
         if n.cost=None then f else
         fN(l|>List.choose(fun n'->if n'.toN=n.toN then None else match n.cost,n'.cost,Map.tryFind (n.toN,n'.toN) G with
                                                                  |Some g,None,Some wg                ->Some {toN=n'.toN;cost=Some(g+wg);fromN=n.toN}
                                                                  |Some g,Some g',Some wg when g+wg<g'->Some {toN=n'.toN;cost=Some(g+wg);fromN=n.toN}
                                                                  |_                                  ->Some n'))((n.fromN,n.toN)::f)
  let r = fN (N|>List.map(fun n->{toN=n;cost=(Map.tryFind(y,n)G);fromN=y})) []
  (fun n->let rec fN z l=match List.tryFind(fun (_,g)->g=z) r with
                         |Some(n',g') when y=n'->Some(n'::g'::l)
                         |Some(n',g')          ->fN n' (g'::l)
                         |_                    ->None
          fN n [])

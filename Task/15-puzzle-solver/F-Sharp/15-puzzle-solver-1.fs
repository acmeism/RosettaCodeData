// A Naive 15 puzzle solver using no memory. Nigel Galloway: October 6th., 2017
let Nr,Nc = [|3;0;0;0;0;1;1;1;1;2;2;2;2;3;3;3|],[|3;0;1;2;3;0;1;2;3;0;1;2;3;0;1;2|]
type G= |N |I |G |E |L
type N={i:uint64;g:G list;e:int;l:int}
let fN     n=let g=(11-n.e)*4 in let a=n.i&&&(15UL<<<g)
             {i=n.i-a+(a<<<16);g=N::n.g;e=n.e+4;l=n.l+(if Nr.[int(a>>>g)]<=n.e/4 then 0 else 1)}
let fI     i=let g=(19-i.e)*4 in let a=i.i&&&(15UL<<<g)
             {i=i.i-a+(a>>>16);g=I::i.g;e=i.e-4;l=i.l+(if Nr.[int(a>>>g)]>=i.e/4 then 0 else 1)}
let fG     g=let l=(14-g.e)*4 in let a=g.i&&&(15UL<<<l)
             {i=g.i-a+(a<<<4) ;g=G::g.g;e=g.e+1;l=g.l+(if Nc.[int(a>>>l)]<=g.e%4 then 0 else 1)}
let fE     e=let l=(16-e.e)*4 in let a=e.i&&&(15UL<<<l)
             {i=e.i-a+(a>>>4) ;g=E::e.g;e=e.e-1;l=e.l+(if Nc.[int(a>>>l)]>=e.e%4 then 0 else 1)}
let fL=let l=[|[I;E];[I;G;E];[I;G;E];[I;G];[N;I;E];[N;I;G;E];[N;I;G;E];[N;I;G];[N;I;E];[N;I;G;E];[N;I;G;E];[N;I;G];[N;E];[N;G;E];[N;G;E];[N;G];|]
       (fun n g->List.except [g] l.[n] |> List.map(fun n->match n with N->fI |I->fN |G->fE |E->fG))
let solve n g l=let rec solve n=match n with // n is board, g is pos of 0, l is max depth
                                |n when n.i =0x123456789abcdef0UL->Some(n.g)
                                |n when n.l>l                    ->None
                                |g->let rec fN=function h::t->match solve h with None->fN t |n->n
                                                       |_->None
                                    fN (fL g.e (List.head n.g)|>List.map(fun n->n g))
                solve {i=n;g=[L];e=g;l=0}
  let n = Seq.collect fN n

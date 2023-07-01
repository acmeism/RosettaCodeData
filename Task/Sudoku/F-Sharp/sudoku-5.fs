// Solve Sudoku Like Puzzles. Nigel Galloway: September 6th., 2018
let fN y n g=let _q n' g'=[for n in n*n'..n*n'+n-1 do for g in g*g'..g*g'+g-1 do yield (n,g)]
             let N=[|for n in 0..(y/n)-1 do for g in 0..(y/g)-1 do yield _q n g|]
             (fun n' g'->N.[((n'/n)*n+g'/g)])
let fI n=let _q g=[for n in 0..n-1 do yield (g,n)]
         let N=[|for n in 0..n-1 do yield _q n|]
         (fun g (_:int)->N.[g])
let fG n=let _q g=[for n in 0..n-1 do yield (n,g)]
         let N=[|for n in 0..n-1 do yield _q n|]
         (fun (_:int) n->N.[n])
let fE v z n g fn=let N,G,B,fn=fI z,fG z,fN z n g,readCSV ',' fn|>List.ofSeq
                  let fG n g mask=List.except (N n g@G n g@B n g) mask
                  let b=List.except(List.map(fun n->(n.row,n.col))fn)[for n in 0..z-1 do for g in 0..z-1 do yield (n,g)]
                  let q=Map.ofList[for v' in v do yield ((v'),List.choose(fun n->if n.value=v' then Some(n.row,n.col) else None)fn|>List.fold(fun z (n,g)->(n,g)::fG n g z)b)]
                  (fG,(fun n->Map.find n q),z,v)
let SLPsolve (N,G,z,l)=
  let rec nQueens col mask res=[
    if col=z then yield res else
    yield! List.filter(fun(n,_)->n=col)mask|>List.collect(fun(n,g)->nQueens (col+1) (N n g mask) ((n,g)::res))]
  let rec sudoku l res=seq{
    match l with
    |h::t->let n=nQueens 0 (List.except (List.concat res) (G h)) []
           yield! n|>Seq.collect(fun n->sudoku t (n::res))
    |_->yield res}
  sudoku l []
let printSLP n g=
  List.map2(fun n g->List.map(fun(n',g')->((n',g'),n))g) (List.rev n) g|>List.concat|>List.sortBy (fun ((_,n),_)->n)|>List.groupBy(fun ((n,_),_)->n)|>List.sortBy(fun(n,_)->n)
  |>List.iter(fun (_,n)->n|>Seq.fold(fun z ((_,g),v)->[z..g-1]|>Seq.iter(fun _->printf " |");printf "%s|" v; g+1 ) 0 |>ignore;printfn "")

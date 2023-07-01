let N=System.Random 23 //Nigel Galloway: August 7th., 2018
let s_of_n_creator i = fun g->Seq.fold(fun (n:_[]) g->if N.Next()%(g+1)>i-1 then n else n.[N.Next()%i]<-g;n) (Array.ofSeq (Seq.take i g)) (Seq.skip i g)
let s_of_n<'n> = s_of_n_creator 3
printfn "using an input array -> %A" (List.init 100000 (fun _->s_of_n [|0..9|]) |> Array.concat |> Array.countBy id |> Array.sort)
printfn "using an input list  -> %A" (List.init 100000 (fun _->s_of_n [0..9]) |> Array.concat |> Array.countBy id |> Array.sort)

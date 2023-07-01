// Metallic Ration. Nigel Galloway: September 16th., 2020
let rec fN i g (e,l)=match i with 0->g |_->fN (i-1) (int(l/e)::g) (e,(l%e)*10I)
let     fI(P:int)=Seq.unfold(fun(n,g)->Some(g,((bigint P)*n+g,n)))(1I,1I)
let     fG fI fN=let _,(n,g)=fI|>Seq.pairwise|>Seq.mapi(fun n g->(n,fN g))|>Seq.pairwise|>Seq.find(fun((_,n),(_,g))->n=g) in (n,List.rev g)
let     mR n g=printf "First 15 elements when P = %d -> " n; fI n|>Seq.take 15|>Seq.iter(printf "%A "); printf "\n%d decimal places " g
               let Σ,n=fG(fI n)(fN (g+1) []) in printf "required %d iterations -> %d." Σ n.Head; List.iter(printf "%d")n.Tail ;printfn ""
[0..9]|>Seq.iter(fun n->mR n 32; printfn ""); mR 1 256

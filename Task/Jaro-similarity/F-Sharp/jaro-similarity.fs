// Calculate Jaro distance of 2 strings. Nigel Galloway: August 7th., 2020
let fG n g=Seq.map2(fun n g->if g=1 then Some n else None) n g |> Seq.choose id
let J (n:string) (g:string)=
  let s1,s2=n.Length,g.Length
  let w,m1,m2=(max s1 s2)/2-1,Array.zeroCreate<int>s1,Array.zeroCreate<int>s2
  g|>Seq.iteri(fun i g->match [max(i-w) 0..min(i+w)(s1-1)]|>Seq.tryFind(fun i->n.[i]=g&&m1.[i]=0) with Some n->m1.[n]<-1;m2.[i]<-1 |_->())
  let t=float(Seq.fold2(fun Σ n g->Σ + (if n<>g then 1 else 0)) 0 (fG n m1) (fG g m2))/2.0
  let m=float(m2|>Array.sum) in if m=0.0 then m else ((m/float s1)+(m/float s2)+((m-t)/m))/3.0

printfn "MARTHA MARHTA->%f" (J "MARTHA" "MARHTA")
printfn "DIXON DICKSONX->%f" (J "DIXON" "DICKSONX")
printfn "JELLYFISH SMELLYFISH->%f" (J "JELLYFISH" "SMELLYFISH")

// Applied dendrology. Nigel Galloway: February 15., 2021
let uT a=let N,G=Array.create(a+1) true, [|yield! primes64()|>Seq.takeWhile((>)(int64 a))|]
         let fN n i e=let mutable p=e-1 in (fun()->p<-p+1; if p<G.Length && (n+i)*(1L+G.[p])-n*G.[p]<=(int64 a) then Some(n,i,p) else None)
         let fG n i e=let g=n+i in let mutable n,l,p=n,1L,1L
                          (fun()->n<-n*G.[e]; p<-p*G.[e]; l<-l+p; let i=g*l-n in if i<=(int64 a) then Some(n,i,e) else None)
         let rec fL n g=match n() with Some(f,i,e)->N.[(int i)]<-false; fL n ((fN f i (e+1))::g)
                                      |_->match g with n::t->match n() with Some (n,i,e)->fL (fG n i e) g |_->fL n t
                                                      |_->N.[0]<-false; N
         fL (fG 1L 0L 0) [fN 1L 0L 1]

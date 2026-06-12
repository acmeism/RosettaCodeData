// Cipolla's algorithm. Nigel Galloway: June 16th., 2019
let Cipolla n g =
  let rec fN i g e l=match e with n when n=0I->i |_ when e%2I=1I->fN ((i*g)%l) ((g*g)%l) (e/2I) l |_-> fN i ((g*g)%l) (e/2I) l
  let rec fG g=match (n/g+g)>>>1 with n when bigint.Abs(g-n)>>>1<2I->n+1I |g->fG g
  let a,b=let rec fI i=let q=i*i-n in if fN 1I q ((g-1I)/2I) g>1I then (i,q) else fI (i+1I) in fI(fG (bigint(sqrt(double n))))
  let fE=Seq.unfold(fun(n,i)->Some((n,i),((n*n+i*i*b)%g,(2I*n*i)%g)))(a,1I)|>Seq.cache
  let rec fL Πn Πi α β=match 2I**α with
                        Ω when Ω<β->fL Πn Πi (α+1) β
                       |Ω when Ω>β->let n,i=Seq.item (α-1) fE in fL ((Πn*n+Πi*i*b)%g) ((Πn*i+Πi*n)%g) 0 (β-Ω/2I)
                       |_->let n,i=Seq.item α fE in ((Πn*n+Πi*i*b)%g)
  if fN 1I n ((g-1I)/2I) g<>1I then None else Some(fL 1I 0I 0 ((g+1I)/2I))

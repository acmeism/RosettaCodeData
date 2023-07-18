// Minkowski question-mark function. Nigel Galloway: July 14th., 2023
let fN g=let n=(int>>float)g in ((if g<0.0 then -1.0 else 1.0),abs n,abs (g-n))
let fI(n,_,(nl,nh))(g,_,(gl,gh))=let l,h=nl+gl,nh+gh in ((n+g)/2.0,(float l)/(float h),(l,h))
let fG n g=(max n g)-(min n g)
let fE(s,z,l)=Seq.unfold(fun(i,e)->let (n,g,_) as r=fI i e in Some((s*(z+n),s*(g+z)),if l<n then (i,r) else if l=n then (r,r) else (r,e)))((0.0,0.0,(0,1)),(1.0,1.0,(1,1)))
let fL(s,z,l)=Seq.unfold(fun(i,e)->let (n,g,_) as r=fI i e in Some((s*(z+n),s*(g+z)),if l<g then (i,r) else if l=g then (r,r) else (r,e)))((0.0,0.0,(0,1)),(1.0,1.0,(1,1)))
let f2M g=let _,(n,_)=fL(fN g)|>Seq.pairwise|>Seq.find(fun((n,_),(g,_))->(fG n g)<2.328306437e-11) in n
let m2F g=let _,(_,n)=fE(fN g)|>Seq.pairwise|>Seq.find(fun((_,n),(_,g))->(fG n g)<2.328306437e-11) in n

printfn $"?(φ) = 5/3 is %A{fG(f2M 1.61803398874989490253)(5.0/3.0)<2.328306437e-10}"
printfn $"?⁻¹(-5/9) = (√13-7)/6 is %A{fG(m2F(-5.0/9.0))((sqrt(13.0)-7.0)/6.0)<2.328306437e-10}"
let n=42.0/23.0 in printfn $"?⁻¹(?(n)) = n is %A{(fG(m2F(f2M n)) n)<2.328306437e-10}"
let n= -3.0/13.0 in printfn $"?(?⁻¹(n)) = n is %A{(fG(f2M(m2F n)) n)<2.328306437e-10}"

// Nigel Galloway: May 21st., 2019
let fN g=let g=int64(sqrt(float(pown g (int(g-1L)))))+1L in (Seq.unfold(fun(n,g)->Some(n,(n+g,g+2L))))(g*g,g*2L+1L)
let fG n g=Array.unfold(fun n->if n=0L then None else let n,g=System.Math.DivRem(n,g) in Some(g,n)) n
let fL g=let n=set[0L..g-1L] in Seq.find(fun x->set(fG x g)=n) (fN g)
let toS n g=let a=Array.concat [[|'0'..'9'|];[|'a'..'f'|]] in System.String(Array.rev(fG n g)|>Array.map(fun n->a.[(int n)]))
[2L..16L]|>List.iter(fun n->let g=fL n in printfn "Base %d: %s² -> %s" n (toS (int64(sqrt(float g))) n) (toS g n))

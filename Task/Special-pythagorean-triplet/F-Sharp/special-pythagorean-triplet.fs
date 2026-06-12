// Special pythagorean triplet. Nigel Galloway: August 31st., 2021
let fG n g=let i=(n-g)/2L in match (n+g)%2L with 0L->if (g*g)%(4L*i)=0L then Some(g,i-(g*g)/(4L*i),i+(g*g)/(4L*i)) else None
                                                |_->if (g*g-2L*i-1L)%(4L*i+2L)=0L then Some(g,i-(g*g)/(4L*i+2L),i+1L+(g*g)/(4L*i+2L)) else None
let E9 n=let fN=fG n in seq{1L..(n-2L)/3L}|>Seq.choose fN|>Seq.iter(fun(n,g,l)->printfn $"%d{n*n}(%d{n})+%d{g*g}(%d{g})=%d{l*l}(%d{l})")
[1L..260L]|>List.iter(fun n->printfn "Sum = %d" n; E9 n)

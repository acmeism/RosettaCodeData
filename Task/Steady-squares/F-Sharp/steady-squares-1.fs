// Steady Squares. Nigel Galloway: December 21st., 2021
let fN g=let n=List.fold2(fun z n g->z+n*g) 0L g (g|>List.rev) in (n,g)
let five,six=(5L,[|0L..9L|]),(6L,[|0L;9L;8L;7L;6L;5L;4L;3L;2L;1L|])
let stdySq(g0,N)=let rec fG n (g,l)=seq{let i=Array.item(int((n+g)%10L)) N in yield i; yield! (fG((n+g+2L*g0*i)/10L)(fN(i::l)))}
                 seq{yield g0; yield! fG(g0*g0/10L)(0L,[])}

(*
Find the point of intersection of 2 lines.
Nigel Galloway May 20th., 2017
*)
type Line={a:float;b:float;c:float} member N.toS=sprintf "%.2fx + %.2fy = %.2f" N.a N.b N.c
let intersect (n:Line) g = match (n.a*g.b-g.a*n.b) with
                           |0.0 ->printfn "%s does not intersect %s" n.toS g.toS
                           |ng  ->printfn "%s intersects %s at x=%.2f y=%.2f" n.toS g.toS ((g.b*n.c-n.b*g.c)/ng) ((n.a*g.c-g.a*n.c)/ng)
let fn (i,g) (e,l) = {a=g-l;b=e-i;c=(e-i)*g+(g-l)*i}
intersect (fn (4.0,0.0) (6.0,10.0)) (fn (0.0,3.0) (10.0,7.0))
intersect {a=3.18;b=4.23;c=7.13} {a=6.36;b=8.46;c=9.75}

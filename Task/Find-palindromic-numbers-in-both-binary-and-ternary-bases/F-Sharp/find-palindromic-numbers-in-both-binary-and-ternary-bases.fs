// Find palindromic numbers in both binary and ternary bases. December 19th., 2018
let fG(n,g)=(Seq.unfold(fun(g,e)->if e<1L then None else Some((g%3L)*e,(g/3L,e/3L)))(n,g/3L)|>Seq.sum)+g+n*g*3L
Seq.concat[seq[0L;1L;2L];Seq.unfold(fun(i,e)->Some (fG(i,e),(i+1L,if i=e-1L then e*3L else e)))(1L,3L)]
  |>Seq.filter(fun n->let n=System.Convert.ToString(n,2).ToCharArray() in n=Array.rev n)|>Seq.take 6|>Seq.iter (printfn "%d")

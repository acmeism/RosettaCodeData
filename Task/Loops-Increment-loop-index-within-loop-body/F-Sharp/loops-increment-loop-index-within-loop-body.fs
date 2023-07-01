// Well I don't do loops. Nigel Galloway: March 17th., 2019. Let me try to explain where the loopy variables are, for the imperatively constrained.
// cUL allows me to claim the rather trivial extra credit (commas in the numbers)
let cUL=let g=System.Globalization.CultureInfo("en-GB") in (fun (n:uint64)->n.ToString("N0",g))
// fN is primality by trial division
let fN g=pCache|>Seq.map uint64|>Seq.takeWhile(fun n->n*n<g)|>Seq.forall(fun n->g%n>0UL)
// unfold is sort of a loop incremented by 1 in this case
let fG n=Seq.unfold(fun n->Some(n,(n+1UL))) n|>Seq.find(fN)
// unfold is sort of a loop with fG as an internal loop incremented by the exit value of the internal loop in this case.
Seq.unfold(fun n->let n=fG n in Some(n,n+n)) 42UL|>Seq.take 42|>Seq.iteri(fun n g->printfn "%2d -> %s"  (n+1) (cUL g))

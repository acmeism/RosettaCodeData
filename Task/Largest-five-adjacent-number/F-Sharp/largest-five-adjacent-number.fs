// Largest five adjacent number. Nigel Galloway: September 28th., 2021
let n()=let n()=System.Random().Next(10) in Seq.unfold(fun g->Some(g,(g%10000)*10+n()))(n()*10000+n()*1000+n()*100+n()*10+n())
printfn $"Largest 5 adjacent digits are %d{(n()|>Seq.take 995|>Seq.max)}"

// Word ladder: Nigel Galloway. June 5th., 2021
let fG n g=n|>List.partition(fun n->2>Seq.fold2(fun z n g->z+if n=g then 0 else 1) 0 n g)
let wL n g=let dict=seq{use n=System.IO.File.OpenText("unixdict.txt") in while not n.EndOfStream do yield n.ReadLine()}|>Seq.filter(Seq.length>>(=)(Seq.length n))|>List.ofSeq|>List.except [n]
           let (|Done|_|) n=n|>List.tryFind((=)g)
           let rec wL n g l=match n with h::t->let i,e=fG l (List.head h) in match i with Done i->Some((i::h)|>List.rev) |_->wL t ((i|>List.map(fun i->i::h))@g) e
                                        |_->match g with []->None |_->wL g [] l
           let i,e=fG dict n in match i with Done i->Some([n;g]) |_->wL(i|>List.map(fun g->[g;n])) [] e
[("boy","man");("girl","lady");("john","jane");("child","adult")]|>List.iter(fun(n,g)->printfn "%s" (match wL n g with Some n->n|>String.concat " -> " |_->n+" into "+g+" can't be done"))

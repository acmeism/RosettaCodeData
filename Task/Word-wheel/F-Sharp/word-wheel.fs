// Word Wheel: Nigel Galloway. May 25th., 2021
let fG k n g=g|>Seq.exists(fun(n,_)->n=k) && g|>Seq.forall(fun(k,g)->Map.containsKey k n && g<=n.[k])
let wW n g=let fG=fG(Seq.item 4 g)(g|>Seq.countBy id|>Map.ofSeq) in seq{use n=System.IO.File.OpenText(n) in while not n.EndOfStream do yield n.ReadLine()}|>Seq.filter(fun n->2<(Seq.length n)&&(Seq.countBy id>>fG)n)
wW "unixdict.txt" "ndeokgelw"|>Seq.iter(printfn "%s")

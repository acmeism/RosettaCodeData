// Generate Sequence of Left Factorials: Nigel Galloway, March 5th., 2019.
let LF=Seq.unfold(fun (Σ,n,g)->Some(Σ,(Σ+n,n*g,g+1I))) (0I,1I,1I)

// Unique characters in each string: Nigel Galloway. May 12th., 2021
let  fN g=g|>Seq.countBy id|>Seq.filter(fun(_,n)->n=1)
let fUc g=g|>List.map fN|>Seq.concat|>Seq.countBy id|>Seq.filter(fun(_,n)->n=List.length g)|>Seq.map(fun((n,_),_)->n)|>Seq.sort
printfn "%s" (fUc ["1a3c52debeffd";"2b6178c97a938stf";"3ycxdb1fgxa2yz"]|>Array.ofSeq|>System.String)

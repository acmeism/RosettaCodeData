// Klarner-Rado sequence. Nigel Galloway: August 19th., 20
let kr()=Seq.unfold(fun(n,g)->Some(g|>Seq.filter((>)n)|>Seq.sort,(n*2L+1L,seq[for n in g do yield n; yield n*2L+1L; yield n*3L+1L]|>Seq.filter((<=)n)|>Seq.distinct)))(3L,seq[1L])|>Seq.concat
let n=kr()|>Seq.take 1000000|>Array.ofSeq in n|>Array.take 100|>Array.iter(printf "%d "); printfn "\nkr[999] is %d\nkr[9999] is %d\nkr[99999] is %d\nkr[999999] is %d" n.[999] n.[9999] n.[99999] n.[999999]

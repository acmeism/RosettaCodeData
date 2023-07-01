// mdr. Nigel Galloway: June 29th., 2021
let rec fG n g=if n=0 then g else fG(n/10)(g*(n%10))
let mdr n=let rec mdr n g=if n<10 then (n,g) else mdr(fG n 1)(g+1) in mdr n 0
[123321; 7739; 893; 899998] |> List.iter(fun i->let n,g=mdr i in printfn "%d has mdr=%d with persitance %d" i n g)
let fN g=Seq.initInfinite id|>Seq.filter((mdr>>fst>>(=)g))|>Seq.take 5
seq{0..9}|>Seq.iter(fun n->printf "First 5 numbers with mdr %d -> " n; Seq.initInfinite id|>Seq.filter((mdr>>fst>>(=)n))|>Seq.take 5|>Seq.iter(printf "%d ");printfn "")

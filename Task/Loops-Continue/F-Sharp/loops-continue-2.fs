let fN g=quibble (Seq.initInfinite(fun n ->if (n+1)%5=0 || (n+1)=List.length g then "\n" else ", ")) g
fN [1] |> Seq.iter(fun(n,g)->printf "%d%s" n g)
fN [1..9] |> Seq.iter(fun(n,g)->printf "%d%s" n g)
fN [1..10] |> Seq.iter(fun(n,g)->printf "%d%s" n g)
fN [1..11] |> Seq.iter(fun(n,g)->printf "%d%s" n g)

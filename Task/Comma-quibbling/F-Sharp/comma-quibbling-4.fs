let fN n = quibble (List.mapi(fun n _->match n with 0->"" |1-> " and " |_->", ") n |> List.rev) n
printf "{"; fN ["ABC"; "DEF"; "G"; "H"] |> Seq.iter(fun(n,g)->printf "%s%s" n g); printfn"}"
printf "{"; fN ["ABC"; "DEF"; "G"] |> Seq.iter(fun(n,g)->printf "%s%s" n g); printfn"}"
printf "{"; fN ["ABC"; "DEF"] |> Seq.iter(fun(n,g)->printf "%s%s" n g); printfn"}"
printf "{"; fN ["ABC"] |> Seq.iter(fun(n,g)->printf "%s%s" n g); printfn"}"
printf "{"; fN [] |> Seq.iter(fun(n,g)->printf "%s%s" n g); printfn"}"

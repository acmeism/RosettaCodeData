[0uy..31uy]|>List.iter(fun n->let g=grayCode n in printfn "%2d -> %5s (%2d) -> %2d" n (System.Convert.ToString(g,2)) g (invGrayCode g))

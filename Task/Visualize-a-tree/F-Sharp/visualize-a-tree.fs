type tree =
    | T of string * tree list

let prefMid = seq { yield "├─"; while true do yield "│ " }
let prefEnd = seq { yield "└─"; while true do yield "  " }
let prefNone = seq { while true do yield "" }

let c2 x y = Seq.map2 (fun u v -> String.concat "" [u; v]) x y

let rec visualize (T(label, children)) pre =
    seq {
        yield (Seq.head pre) + label
        if children <> [] then
            let preRest = Seq.skip 1 pre
            let last = Seq.last (List.toSeq children)
            for e in children do
                if e = last then yield! visualize e (c2 preRest prefEnd)
                else yield! visualize e (c2 preRest prefMid)
    }

let example =
    T ("root",
            [T ("a",
                    [T ("a1",
                            [T ("a11", []);
                            T ("a12", []) ]) ]);
            T ("b",
                    [T ("b1", []) ]) ])

visualize example prefNone
|> Seq.iter (printfn "%s")

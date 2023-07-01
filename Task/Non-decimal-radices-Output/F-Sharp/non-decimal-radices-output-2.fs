let bases = [2; 8; 10; 16]

ns |> Seq.map (fun n -> Seq.initInfinite (fun i -> n))
|> Seq.map (fun s -> Seq.zip s bases)
|> Seq.map (Seq.map System.Convert.ToString >> Seq.toList)
|> Seq.iter (fun s -> (printfn "%6s %2s %2s %2s" s.[0] s.[1] s.[2] s.[3]))

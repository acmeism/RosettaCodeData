let ls = DirectoryInfo(".").EnumerateFileSystemInfos() |> Seq.map (fun i -> i.Name) |> Seq.sort |> Seq.iter (printfn "%s")

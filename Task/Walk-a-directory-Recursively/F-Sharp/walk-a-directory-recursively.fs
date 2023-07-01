open System.IO

let rec getAllFiles dir pattern =
    seq { yield! Directory.EnumerateFiles(dir, pattern)
          for d in Directory.EnumerateDirectories(dir) do
              yield! getAllFiles d pattern }

getAllFiles "c:\\temp" "*.xml"
|> Seq.iter (printfn "%s")

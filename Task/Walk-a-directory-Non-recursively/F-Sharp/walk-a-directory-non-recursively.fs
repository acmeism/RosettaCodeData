System.IO.Directory.GetFiles("c:\\temp", "*.xml")
|> Array.iter (printfn "%s")

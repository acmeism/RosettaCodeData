#r "System.Xml.Linq.dll"

let uri1 = "http://www.rosettacode.org/w/api.php?action=query&list=categorymembers&cmtitle=Category:Programming_Tasks&cmlimit=500&format=xml"
let uri2 task = sprintf "http://www.rosettacode.org/w/index.php?title=%s&action=raw" task

[|for xml in (System.Xml.Linq.XDocument.Load uri1).Root.Descendants() do
    for attrib in xml.Attributes() do
      if attrib.Name.LocalName = "title" then
        yield async {
          let uri = uri2 (attrib.Value.Replace(" ", "_") |> System.Web.HttpUtility.UrlEncode)
          use client = new System.Net.WebClient()
          let! html = client.AsyncDownloadString(System.Uri uri)
          let sols' = html.Split([|"{{header|"|], System.StringSplitOptions.None).Length - 1
          lock stdout (fun () -> printfn "%s: %d examples" attrib.Value sols')
          return sols' }|]
|> Async.Parallel
|> Async.RunSynchronously
|> fun xs -> printfn "Total: %d examples" (Seq.sum xs)

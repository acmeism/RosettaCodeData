open System.Net
open System.IO

let wgetAsync url =
    async { let request = WebRequest.Create (url:string)
            use! response = request.AsyncGetResponse()
            use responseStream = response.GetResponseStream()
            use reader = new StreamReader(responseStream)
            return reader.ReadToEnd() }

let urls = ["http://www.rosettacode.org/"; "http://www.yahoo.com/"; "http://www.google.com/"]
let content = urls
              |> List.map wgetAsync
              |> Async.Parallel
              |> Async.RunSynchronously

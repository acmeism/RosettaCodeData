open System
open System.Net
open System.Text.RegularExpressions

async {
    use wc = new WebClient()
    let! html = wc.AsyncDownloadString(Uri("http://tycho.usno.navy.mil/cgi-bin/timer.pl"))
    return Regex.Match(html, @"<BR>(.+ UTC)").Groups.[1].Value
}
|> Async.RunSynchronously
|> printfn "%s"

open System
open System.Net

let url = "https://rosettacode.org/favicon.ico"

let download (url: string) =
    use client = new WebClient()
    client.DownloadData url

let raw = download url
let encoded = Convert.ToBase64String raw

printfn "%s" encoded

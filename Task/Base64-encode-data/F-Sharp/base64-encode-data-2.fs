open System.Net

let encode s =
    let chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/".ToCharArray()
                |> Array.map string
    let paddingSize =
        let c = Array.length s % 3
        if c = 0 then 0 else 3 - c
    let s = Array.append s (Array.replicate paddingSize (byte '\x00')) |> Array.map int
    let calc c =
        let n = (s.[c] <<< 16) + (s.[c + 1] <<< 8) + s.[c + 2]
        let n1 = (n >>> 18) &&& 63
        let n2 = (n >>> 12) &&& 63
        let n3 = (n >>> 6) &&& 63
        let n4 = n &&& 63
        chars.[n1] + chars.[n2] + chars.[n3] + chars.[n4]
    [0..3..Array.length s - 1]
    |> List.map calc
    |> List.reduce (+)
    |> fun r -> r.Substring(0, String.length r - paddingSize) + String.replicate paddingSize "="

let url = "https://rosettacode.org/favicon.ico"

let download (url: string) =
    use client = new WebClient()
    client.DownloadData url

let encoded = url |> download |> encode

printfn "%s" encoded

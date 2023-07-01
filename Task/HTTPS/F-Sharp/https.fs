#light
let wget (url : string) =
    let c = new System.Net.WebClient()
    c.DownloadString(url)

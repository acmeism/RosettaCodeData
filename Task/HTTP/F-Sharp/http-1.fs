let wget (url : string) =
    use c = new System.Net.WebClient()
    c.DownloadString(url)

printfn "%s" (wget "http://www.rosettacode.org/")

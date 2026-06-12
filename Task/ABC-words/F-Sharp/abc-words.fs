// ABC words. Nigel Galloway: August 29th., 2024
let isABC n=System.Text.RegularExpressions.Regex.Match(n,"^[^bc]*a[^c]*b.*c").Value.Length>0
System.IO.File.ReadLines "unixdict.txt"|>Seq.filter izABC|>Seq.iter(printfn "%s")

open System.Security.Cryptography
open System.Text

"Rosetta code"
|> Encoding.ASCII.GetBytes
|> (new SHA256Managed()).ComputeHash
|> System.BitConverter.ToString
|> printfn "%s"

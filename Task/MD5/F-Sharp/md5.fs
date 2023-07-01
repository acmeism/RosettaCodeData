let md5ootb (msg: string) =
  use md5 = System.Security.Cryptography.MD5.Create()
  msg
  |> System.Text.Encoding.ASCII.GetBytes
  |> md5.ComputeHash
  |> Seq.map (fun c -> c.ToString("X2"))
  |> Seq.reduce ( + )

md5ootb @"The quick brown fox jumped over the lazy dog's back"

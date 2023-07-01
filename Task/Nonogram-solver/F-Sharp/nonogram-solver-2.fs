let fe (n : array<string>) i = n |> Array.collect (fun n -> [|N.fn [for g in n -> ((int)g-64)] i|])
let fl (n : array<string>) (i : array<string>) = (fe n i.Length), (fe i n.Length)
let rFile =
  try
    use file = File.OpenText @"nonogram.txt"
    Some(fl (file.ReadLine().Split ' ') (file.ReadLine().Split ' '))
  with | _  -> printfn "Error reading file" ; None

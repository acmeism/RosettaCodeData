let list = ["a"; "b"; "c"; "d"; "e"]
let rand = new System.Random()
printfn "%s" list.[rand.Next(list.Length)]

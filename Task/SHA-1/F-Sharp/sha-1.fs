let n = System.Security.Cryptography.SHA1.Create()
Array.iter (printf "%x ") (n.ComputeHash "Rosetta Code"B)

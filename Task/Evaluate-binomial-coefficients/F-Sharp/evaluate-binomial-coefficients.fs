let choose n k = List.fold (fun s i -> s * (n-i+1)/i ) 1 [1..k]

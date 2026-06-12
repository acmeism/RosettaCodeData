// Generate random numbers without repeating a value. Nigel Galloway: August 27th., 2021
MathNet.Numerics.Combinatorics.GeneratePermutation 20|>Array.map((+)1)|>Array.iter(printf "%d "); printfn ""

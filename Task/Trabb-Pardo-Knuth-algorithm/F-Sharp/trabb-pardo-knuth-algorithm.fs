module ``Trabb Pardo - Knuth``
open System
let f (x: float) = sqrt(abs x) + (5.0 * (x ** 3.0))

Console.WriteLine "Enter 11 numbers:"
[for _ in 1..11 -> Convert.ToDouble(Console.ReadLine())]
|> List.rev |> List.map f |> List.iter (function
| n when n <= 400.0 -> Console.WriteLine(n)
| _                 -> Console.WriteLine("Overflow"))

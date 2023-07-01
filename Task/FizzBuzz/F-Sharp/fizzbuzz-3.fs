let (|MultipleOf|_|) divisors number =
    if Seq.exists ((%) number >> (<>) 0) divisors
    then None
    else Some ()

let fizzbuzz = function
| MultipleOf [3; 5] -> "fizzbuzz"
| MultipleOf [3]    -> "fizz"
| MultipleOf [5]    -> "buzz"
| n                 -> string n

{ 1 .. 100 }
|> Seq.iter (fizzbuzz >> printfn "%s")

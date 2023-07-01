// Generate Magnanimous numbers. Nigel Galloway: March 20th., 2020
let rec fN n g = match (g/n,g%n) with
                  (0,_)                    -> true
                 |(α,β) when isPrime (α+β) -> fN (n*10) g
                 |_                        -> false
let Magnanimous = let Magnanimous = fN 10 in seq{yield! {0..9}; yield! Seq.initInfinite id |> Seq.skip 10 |> Seq.filter Magnanimous}

// Generate Faulhaber's Triangle. Nigel Galloway: May 8th., 2018
let Faulhaber=let fN n = (1N - List.sum n)::n
              let rec Faul a b=seq{let t = fN (List.mapi(fun n g->b*g/BigRational.FromInt(n+2)) a)
                                   yield t
                                   yield! Faul t (b+1N)}
              Faul [] 0N

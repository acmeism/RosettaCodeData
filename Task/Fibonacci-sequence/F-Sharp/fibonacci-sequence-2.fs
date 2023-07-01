let rec fib = seq { yield! [0;1];
                    for (a,b) in Seq.zip fib (Seq.skip 1 fib) -> a+b}

type ListMonad() =
   member o.Bind(  (m:'a list), (f: 'a -> 'b list) ) = List.concat( List.map f m )
   member o.Return(x) = [x]
   member o.Zero()    = []

let list = ListMonad()

let pyth_triples n = list { let! x = [1..n]
                            let! y = [x..n]
                            let! z = [y..n]
                            if x*x + y*y = z*z then return (x,y,z) }

printf "%A" (pyth_triples 100)

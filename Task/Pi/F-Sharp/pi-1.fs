let rec g q r t k n l = seq {
    if 4I*q+r-t < n*t
    then
        yield n
        yield! (g (10I*q) (10I*(r-n*t)) t k ((10I*(3I*q+r))/t - 10I*n) l)
    else
        yield! (g (q*k) ((2I*q+r)*l) (t*l) (k+1I) ((q*(7I*k+2I)+r*l)/(t*l)) (l+2I))
}

let π = (g 1I 0I 1I 1I 3I 3I)

Seq.take 1 π |> Seq.iter (printf "%A.")
// 6 digits beginning at position 762 of π are '9'
Seq.take 767 (Seq.skip 1 π) |> Seq.iter (printf "%A")

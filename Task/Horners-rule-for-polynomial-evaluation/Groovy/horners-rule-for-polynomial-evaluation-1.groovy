def hornersRule = { coeff, x -> coeff.reverse().inject(0) { accum, c -> (accum * x) + c } }

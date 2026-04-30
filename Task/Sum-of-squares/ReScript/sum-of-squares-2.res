let sumOfSquares = (acc, item) => { acc +. item *. item }

Js.log(Js.Array2.reduce([10., 2., 4.], sumOfSquares, 0.))

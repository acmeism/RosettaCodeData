(function (n) {

    // ENCODING A SET COMPREHENSION IN TERMS OF A LIST MONAD

    // Pythagorean triples drawn from integers in the range [1..25]


    // Each range of integers here represents the set of possible values for the variable.
    // Where the test returns true for a particular [x, y, z] triple, we return that triple
    // to the expected data type, wrapping it using the unit or return function;

    // Where the test returns false, we return the empty list, which vanishes from the
    // results set under concatenation, giving us a convenient encoding of filtering.

    // {(x, y, z) | x <- [1..n], y <- [x+1..n], z <- [y+1..n], (x^2 + y^2 = z^2)}

    return bind(rng(1,     n), function (x) {
    return bind(rng(1 + x, n), function (y) {
    return bind(rng(1 + y, n), function (z) {

        return (x * x + y * y === z * z) ? unit([x, y, z]) : [];

    })})});


    // Monadic return/unit/inject for lists just wraps a value in a list
    // a -> [a]
    function unit(a) {
        return [a];
    }

    // Bind for lists is simply ConcatMap
    // which applies a function f directly to each value in the list,
    // and returns the set of results as a concat-flattened list
    // [a] -> (a -> [b]) -> [b]
    function bind(xs, f) {
        return [].concat.apply([], xs.map(f));
    }



    // we will need some ranges of integers, each expressing a range of possible values
    // [m..n]
    function rng(m, n) {
        return Array.apply(null, Array(n - m + 1))
            .map(function (x, i) {
                return m + i;
            });
    }

})(25);

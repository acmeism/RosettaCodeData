// USING A LIST MONAD DIRECTLY, WITHOUT SPECIAL SYNTAX FOR LIST COMPREHENSIONS

(function (n) {

    return mb(r(1,     n), function (x) {  // x <- [1..n]
    return mb(r(1 + x, n), function (y) {  // y <- [1+x..n]
    return mb(r(1 + y, n), function (z) {  // z <- [1+y..n]

       return x * x + y * y === z * z ? [[x, y, z]] : [];

    })})});


    // LIBRARY FUNCTIONS

    // Monadic bind for lists
    function mb(xs, f) {
        return [].concat.apply([], xs.map(f));
    }

    // Monadic return for lists is simply lambda x -> [x]
    // as in [[x, y, z]] : [] above

    // Integer range [m..n]
    function r(m, n) {
        return Array.apply(null, Array(n - m + 1))
            .map(function (n, x) {
                return m + x;
            });
    }

})(100);

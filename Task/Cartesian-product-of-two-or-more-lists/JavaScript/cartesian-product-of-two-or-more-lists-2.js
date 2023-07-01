(() => {

    // CARTESIAN PRODUCT OF TWO LISTS ---------------------

    // cartesianProduct :: [a] -> [b] -> [(a, b)]
    const cartesianProduct = xs =>
        ap(xs.map(Tuple));


    // GENERIC FUNCTIONS ----------------------------------

    // e.g. [(*2),(/2), sqrt] <*> [1,2,3]
    // -->  ap([dbl, hlf, root], [1, 2, 3])
    // -->  [2,4,6,0.5,1,1.5,1,1.4142135623730951,1.7320508075688772]

    // Each member of a list of functions applied to each
    // of a list of arguments, deriving a list of new values.

    // ap (<*>) :: [(a -> b)] -> [a] -> [b]
    const ap = fs => xs =>
        // The sequential application of each of a list
        // of functions to each of a list of values.
        fs.flatMap(
            f => xs.map(f)
        );

    // Tuple (,) :: a -> b -> (a, b)
    const Tuple = a => b => [a, b];

    // TEST -----------------------------------------------
    return [
            cartesianProduct([1, 2])([3, 4]),
            cartesianProduct([3, 4])([1, 2]),
            cartesianProduct([1, 2])([]),
            cartesianProduct([])([1, 2]),
        ]
        .map(JSON.stringify)
        .join('\n');
})();

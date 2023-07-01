(function () {
    'use strict';

    // NUMBERING CONSTRAINTS --------------------------------------------------

    // options :: Int -> Int -> Int -> [(Int, Int, Int)]
    function options(lo, hi, total) {
        var bind = flip(concatMap),
            ds = enumFromTo(lo, hi);

        return bind(filter(even, ds),
            function (x) { // X is even,
                return bind(filter(function (d) { return d !== x; }, ds),
            function (y) { // Y is distinct from X,
                return bind([total - (x + y)],
            function (z) { // Z sums with x and y to total, and is in ds.
                return z !== y && lo <= z && z <= hi ? [
                    [x, y, z]
                ] : [];
            })})})};

    // GENERIC FUNCTIONS ------------------------------------------------------

    // concatMap :: (a -> [b]) -> [a] -> [b]
    function concatMap(f, xs) {
        return [].concat.apply([], xs.map(f));
    };

    // enumFromTo :: Int -> Int -> [Int]
    function enumFromTo(m, n) {
        return Array.from({
            length: Math.floor(n - m) + 1
        }, function (_, i) {
            return m + i;
        });
    };

    // even :: Integral a => a -> Bool
    function even(n) {
        return n % 2 === 0;
    };

    // filter :: (a -> Bool) -> [a] -> [a]
    function filter(f, xs) {
        return xs.filter(f);
    };

    // flip :: (a -> b -> c) -> b -> a -> c
    function flip(f) {
        return function (a, b) {
            return f.apply(null, [b, a]);
        };
    };

    // length :: [a] -> Int
    function length(xs) {
        return xs.length;
    };

    // map :: (a -> b) -> [a] -> [b]
    function map(f, xs) {
        return xs.map(f);
    };

    // show :: a -> String
    function show(x) {
        return JSON.stringify(x);
    }; //, null, 2);

    // unlines :: [String] -> String
    function unlines(xs) {
        return xs.join('\n');
    };

    // TEST -------------------------------------------------------------------
    var xs = options(1, 7, 12);
    return '(Police, Sanitation, Fire)\n\n' +
        unlines(map(show, xs)) + '\n\nNumber of options: ' + length(xs);
})();

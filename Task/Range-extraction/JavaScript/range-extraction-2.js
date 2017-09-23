(function () {
    'use strict';

    // rangeFormat :: [Int] -> String
    var rangeFormat = function (xs) {
        return splitBy(function (a, b) {
                return b - a > 1;
            }, xs)
            .map(rangeString)
            .join(',');
    };

    // rangeString :: [Int] -> String
    var rangeString = function (xs) {
        return xs.length > 2 ? [head(xs), last(xs)].map(show)
            .join('-') : xs.join(',');
    };

    // GENERIC FUNCTIONS

    // Splitting not on a delimiter, but whenever the relationship between
    // two consecutive items matches a supplied predicate function

    // splitBy :: (a -> a -> Bool) -> [a] -> [[a]]
    var splitBy = function (f, xs) {
        if (xs.length < 2) return [xs];
        var h = head(xs),
            lstParts = xs.slice(1)
            .reduce(function (a, x) {
                var acc = a[0],
                    active = a[1],
                    prev = a[2];

                return f(prev, x) ? (
                    [acc.concat([active]), [x], x]
                ) : [acc, active.concat(x), x];
            }, [
                [],
                [h], h
            ]);
        return lstParts[0].concat([lstParts[1]]);
    };

    // head :: [a] -> a
    var head = function (xs) {
        return xs.length ? xs[0] : undefined;
    };

    // last :: [a] -> a
    var last = function (xs) {
        return xs.length ? xs.slice(-1)[0] : undefined;
    };

    // show :: a -> String
    var show = function (x) {
        return JSON.stringify(x);
    };

    // TEST
    return rangeFormat([0, 1, 2, 4, 6, 7, 8, 11, 12, 14, 15, 16,
        17, 18, 19, 20, 21, 22, 23, 24, 25, 27, 28, 29, 30, 31, 32,
        33, 35, 36, 37, 38, 39
    ]);
})();

(function () {
    'use strict';

    // GENERIC FUNCTIONS

    // concatMap :: (a -> [b]) -> [a] -> [b]
    var concatMap = function concatMap(f, xs) {
            return [].concat.apply([], xs.map(f));
        },

        // curry :: ((a, b) -> c) -> a -> b -> c
        curry = function curry(f) {
            return function (a) {
                return function (b) {
                    return f(a, b);
                };
            };
        },

        // intersectBy :: (a - > a - > Bool) - > [a] - > [a] - > [a]
        intersectBy = function intersectBy(eq, xs, ys) {
            return xs.length && ys.length ? xs.filter(function (x) {
                return ys.some(curry(eq)(x));
            }) : [];
        },

        // range :: Int -> Int -> Maybe Int -> [Int]
        range = function range(m, n, step) {
            var d = (step || 1) * (n >= m ? 1 : -1);
            return Array.from({
                length: Math.floor((n - m) / d) + 1
            }, function (_, i) {
                return m + i * d;
            });
        };

    // PROBLEM FUNCTIONS

    // add, mul :: (Int, Int) -> Int
    var add = function add(xy) {
            return xy[0] + xy[1];
        },
        mul = function mul(xy) {
            return xy[0] * xy[1];
        };

    // sumEq, mulEq :: (Int, Int) -> [(Int, Int)]
    var sumEq = function sumEq(p) {
            var addP = add(p);
            return s1.filter(function (q) {
                return add(q) === addP;
            });
        },
        mulEq = function mulEq(p) {
            var mulP = mul(p);
            return s1.filter(function (q) {
                return mul(q) === mulP;
            });
        };

    // pairEQ :: ((a, a) -> (a, a)) -> Bool
    var pairEQ = function pairEQ(a, b) {
        return a[0] === b[0] && a[1] === b[1];
    };

    // MAIN

    // xs :: [Int]
    var xs = range(1, 100);

    // s1 s2, s3, s4 :: [(Int, Int)]
    var s1 = concatMap(function (x) {
            return concatMap(function (y) {
                return 1 < x && x < y && x + y < 100 ? [
                    [x, y]
                ] : [];
            }, xs);
        }, xs),

        s2 = s1.filter(function (p) {
            return sumEq(p).every(function (q) {
                return mulEq(q).length > 1;
            });
        }),

        s3 = s2.filter(function (p) {
            return intersectBy(pairEQ, mulEq(p), s2).length === 1;
        }),

        s4 = s3.filter(function (p) {
            return intersectBy(pairEQ, sumEq(p), s3).length === 1;
        });

    return s4;
})();

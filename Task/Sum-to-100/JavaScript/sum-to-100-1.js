(function () {
    'use strict';

    // GENERIC FUNCTIONS ----------------------------------------------------

    // permutationsWithRepetition :: Int -> [a] -> [[a]]
    var permutationsWithRepetition = function (n, as) {
        return as.length > 0 ?
            foldl1(curry(cartesianProduct)(as), replicate(n, as)) : [];
    };

    // cartesianProduct :: [a] -> [b] -> [[a, b]]
    var cartesianProduct = function (xs, ys) {
        return [].concat.apply([], xs.map(function (x) {
            return [].concat.apply([], ys.map(function (y) {
                return [
                    [x].concat(y)
                ];
            }));
        }));
    };

    // curry :: ((a, b) -> c) -> a -> b -> c
    var curry = function (f) {
        return function (a) {
            return function (b) {
                return f(a, b);
            };
        };
    };

    // flip :: (a -> b -> c) -> b -> a -> c
    var flip = function (f) {
        return function (a, b) {
            return f.apply(null, [b, a]);
        };
    };

    // foldl1 :: (a -> a -> a) -> [a] -> a
    var foldl1 = function (f, xs) {
        return xs.length > 0 ? xs.slice(1)
            .reduce(f, xs[0]) : [];
    };

    // replicate :: Int -> a -> [a]
    var replicate = function (n, a) {
        var v = [a],
            o = [];
        if (n < 1) return o;
        while (n > 1) {
            if (n & 1) o = o.concat(v);
            n >>= 1;
            v = v.concat(v);
        }
        return o.concat(v);
    };

    // group :: Eq a => [a] -> [[a]]
    var group = function (xs) {
        return groupBy(function (a, b) {
            return a === b;
        }, xs);
    };

    // groupBy :: (a -> a -> Bool) -> [a] -> [[a]]
    var groupBy = function (f, xs) {
        var dct = xs.slice(1)
            .reduce(function (a, x) {
                var h = a.active.length > 0 ? a.active[0] : undefined,
                    blnGroup = h !== undefined && f(h, x);

                return {
                    active: blnGroup ? a.active.concat(x) : [x],
                    sofar: blnGroup ? a.sofar : a.sofar.concat([a.active])
                };
            }, {
                active: xs.length > 0 ? [xs[0]] : [],
                sofar: []
            });
        return dct.sofar.concat(dct.active.length > 0 ? [dct.active] : []);
    };

    // compare :: a -> a -> Ordering
    var compare = function (a, b) {
        return a < b ? -1 : a > b ? 1 : 0;
    };

    // on :: (b -> b -> c) -> (a -> b) -> a -> a -> c
    var on = function (f, g) {
        return function (a, b) {
            return f(g(a), g(b));
        };
    };

    // nub :: [a] -> [a]
    var nub = function (xs) {
        return nubBy(function (a, b) {
            return a === b;
        }, xs);
    };

    // nubBy :: (a -> a -> Bool) -> [a] -> [a]
    var nubBy = function (p, xs) {
        var x = xs.length ? xs[0] : undefined;

        return x !== undefined ? [x].concat(nubBy(p, xs.slice(1)
            .filter(function (y) {
                return !p(x, y);
            }))) : [];
    };

    // find :: (a -> Bool) -> [a] -> Maybe a
    var find = function (f, xs) {
        for (var i = 0, lng = xs.length; i < lng; i++) {
            if (f(xs[i], i)) return xs[i];
        }
        return undefined;
    };

    // Int -> [a] -> [a]
    var take = function (n, xs) {
        return xs.slice(0, n);
    };

    // unlines :: [String] -> String
    var unlines = function (xs) {
        return xs.join('\n');
    };

    // show :: a -> String
    var show = function (x) {
        return JSON.stringify(x);
    }; //, null, 2);

    // head :: [a] -> a
    var head = function (xs) {
        return xs.length ? xs[0] : undefined;
    };

    // tail :: [a] -> [a]
    var tail = function (xs) {
        return xs.length ? xs.slice(1) : undefined;
    };

    // length :: [a] -> Int
    var length = function (xs) {
        return xs.length;
    };

    // SIGNED DIGIT SEQUENCES  (mapped to sums and to strings)

    // data Sign :: [ 0 | 1 | -1 ] = ( Unsigned | Plus | Minus )
    // asSum :: [Sign] -> Int
    var asSum = function (xs) {
        var dct = xs.reduceRight(function (a, sign, i) {
            var d = i + 1; //  zero-based index to [1-9] positions
            if (sign !== 0) {
                // Sum increased, digits cleared
                return {
                    digits: [],
                    n: a.n + sign * parseInt([d].concat(a.digits)
                        .join(''), 10)
                };
            } else return { // Digits extended, sum unchanged
                digits: [d].concat(a.digits),
                n: a.n
            };
        }, {
            digits: [],
            n: 0
        });
        return dct.n + (
            dct.digits.length > 0 ? parseInt(dct.digits.join(''), 10) : 0
        );
    };

    // data Sign :: [ 0 | 1 | -1 ] = ( Unsigned | Plus | Minus )
    // asString :: [Sign] -> String
    var asString = function (xs) {
        var ns = xs.reduce(function (a, sign, i) {
            var d = (i + 1)
                .toString();
            return sign === 0 ? a + d : a + (sign > 0 ? ' +' : ' -') + d;
        }, '');

        return ns[0] === '+' ? tail(ns) : ns;
    };

    // SUM T0 100 ------------------------------------------------------------

    // universe :: [[Sign]]
    var universe = permutationsWithRepetition(9, [0, 1, -1])
        .filter(function (x) {
            return x[0] !== 1;
        });

    // allNonNegativeSums :: [Int]
    var allNonNegativeSums = universe.map(asSum)
        .filter(function (x) {
            return x >= 0;
        })
        .sort();

    // uniqueNonNegativeSums :: [Int]
    var uniqueNonNegativeSums = nub(allNonNegativeSums);

    return ["Sums to 100:\n", unlines(universe.filter(function (x) {
                return asSum(x) === 100;
            })
            .map(asString)),

        "\n\n10 commonest sums (sum, followed by number of routes to it):\n",
        show(take(10, group(allNonNegativeSums)
            .sort(on(flip(compare), length))
            .map(function (xs) {
                return [xs[0], xs.length];
            }))),

        "\n\nFirst positive integer not expressible as a sum of this kind:\n",
        show(find(function (x, i) {
            return x !== i;
        }, uniqueNonNegativeSums.sort(compare)) - 1), // zero-based index

        "\n10 largest sums:\n",
        show(take(10, uniqueNonNegativeSums.sort(flip(compare))))
    ].join('\n') + '\n';
})();

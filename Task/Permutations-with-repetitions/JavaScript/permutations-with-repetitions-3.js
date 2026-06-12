(function () {
    'use strict';

    // nthPermutationWithRepn :: [a] -> Int -> Int -> [a]
    var nthPermutationWithRepn = function (xs, groupSize, index) {
        var intBase = xs.length,
            intSetSize = Math.pow(intBase, groupSize),
            lastIndex = intSetSize - 1; // zero-based

        if (intBase < 1 || index > lastIndex) return undefined;

        var baseElements = unfoldr(function (m) {
                var v = m.new,
                    d = Math.floor(v / intBase);
                return {
                    valid: d > 0,
                    value: xs[v % intBase],
                    new: d
                };
            }, index),
            intZeros = groupSize - baseElements.length;

        return intZeros > 0 ? replicate(intZeros, xs[0])
            .concat(baseElements) : baseElements;
    };

    // GENERIC FUNCTIONS

    // unfoldr :: (b -> Maybe (a, b)) -> b -> [a]
    var unfoldr = function (mf, v) {
        var xs = [];
        return [until(function (m) {
                return !m.valid;
            }, function (m) {
                var m2 = mf(m);
                return m2.valid && (xs = [m2.value].concat(xs)), m2;
            }, {
                valid: true,
                value: v,
                new: v
            })
            .value
        ].concat(xs);
    };

    // until :: (a -> Bool) -> (a -> a) -> a -> a
    var until = function (p, f, x) {
        var v = x;
        while (!p(v)) {
            v = f(v);
        }
        return v;
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

    // show :: a -> String
    var show = function (x) {
        return JSON.stringify(x);
    }; //, null, 2);

    // curry :: Function -> Function
    var curry = function (f) {
        for (var lng = arguments.length,
                args = Array(lng > 1 ? lng - 1 : 0),
                iArg = 1; iArg < lng; iArg++) {
            args[iArg - 1] = arguments[iArg];
        }

        var intArgs = f.length,
            go = function (xs) {
                return xs.length >= intArgs ? f.apply(null, xs) : function () {
                    return go(xs.concat([].slice.apply(arguments)));
                };
            };
        return go([].slice.call(args, 1));
    };

    // range :: Int -> Int -> [Int]
    var range = function (m, n) {
        return Array.from({
            length: Math.floor(n - m) + 1
        }, function (_, i) {
            return m + i;
        });
    };

    // TEST
    // Just items 30 to 35 in the (zero-indexed) series:
    return show(range(30, 35)
        .map(curry(nthPermutationWithRepn)(['X', 'Y', 'Z'], 4)));
})();

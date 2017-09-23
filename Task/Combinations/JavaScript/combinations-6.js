(() => {

    // combinations :: Int -> [a] -> [[a]]
    const combinations = (n, xs) => {
        const cmb_ = (n, xs) => {
            if (n < 1) return [
                []
            ];
            if (xs.length === 0) return [];
            const h = xs[0],
                tail = xs.slice(1);
            return cmb_(n - 1, tail)
                .map(cons(h))
                .concat(cmb_(n, tail));
        };
        return memoized(cmb_)(n, xs);
    }

    // GENERIC FUNCTIONS ------------------------------------------------------

    // 2 or more arguments
    // curry :: Function -> Function
    const curry = (f, ...args) => {
        const go = xs => xs.length >= f.length ? (f.apply(null, xs)) :
            function () {
                return go(xs.concat(Array.from(arguments)));
            };
        return go([].slice.call(args, 1));
    };

    // cons :: a -> [a] -> [a]
    const cons = curry((x, xs) => [x].concat(xs));

    // enumFromTo :: Int -> Int -> [Int]
    const enumFromTo = (m, n) =>
        Array.from({
            length: Math.floor(n - m) + 1
        }, (_, i) => m + i);

    // Derive a memoized version of a function
    // memoized :: Function -> Function
    const memoized = f => {
        let m = {};
        return function (x) {
            let args = [].slice.call(arguments),
                strKey = args.join('-'),
                v = m[strKey];
            return (
                (v === undefined) &&
                (m[strKey] = v = f.apply(null, args)),
                v
            );
        }
    };

    // show :: a -> String
    const show = (...x) =>
        JSON.stringify.apply(
            null, x.length > 1 ? [x[0], null, x[1]] : x
        );

    return show(
        memoized(combinations)(3, enumFromTo(0, 4))
    );
})();

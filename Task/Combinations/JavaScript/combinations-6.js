(function (n) {
    'use strict';


    // n -> [a] -> [[a]]
    let comb = (n, xs) => {
            if (n < 1) return [[]];
            if (xs.length === 0) return [];

            let h = xs[0],
                tail = xs.slice(1);

            return comb(n - 1, tail)
                .map((t) => [h].concat(t))
                .concat(comb(n, tail));
        },



        // Derive a memoized version of a function
        // Function -> Function
        memoized = (f) => {
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
        },

        range = (m, n) =>
            Array.from({
                length: (n - m) + 1
            }, (_, i) => m + i);


    return memoized(comb)(n, range(0, 4))


})(3);

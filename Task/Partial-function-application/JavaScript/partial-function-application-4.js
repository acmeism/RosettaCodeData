(() => {
    'use strict';

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

    // map :: (a -> b) -> [a] -> [b]
    const map = curry((f, xs) => xs.map(f));

    // PARTIAL APPLICATION ----------------------------------------------------
    const
        f1 = x => x * 2,
        f2 = x => x * x,

        fs = map,

        fsf1 = fs(f1),
        fsf2 = fs(f2);

    // TEST -------------------------------------------------------------------
    return [
        fsf1([0, 1, 2, 3]),
        fsf2([0, 1, 2, 3]),

        fsf1([2, 4, 6, 8]),
        fsf2([2, 4, 6, 8])
    ];
})();

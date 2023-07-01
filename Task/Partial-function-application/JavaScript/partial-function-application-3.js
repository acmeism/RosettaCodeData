(() => {
    'use strict';

    // GENERIC FUNCTIONS ------------------------------------------------------

    // curry :: ((a, b) -> c) -> a -> b -> c
    const curry = f => a => b => f(a, b);

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

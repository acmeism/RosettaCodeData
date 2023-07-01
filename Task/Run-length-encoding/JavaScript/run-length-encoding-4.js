(() => {
    'use strict';

    // runLengthEncode :: String -> [(Int, Char)]
    const runLengthEncoded = s =>
        group(s.split('')).map(
            cs => [cs.length, cs[0]]
        );

    // runLengthDecoded :: [(Int, Char)] -> String
    const runLengthDecoded = pairs =>
        pairs.map(([n, c]) => c.repeat(n)).join('');


    // ------------------------TEST------------------------
    const main = () => {
        const
            xs = 'WWWWWWWWWWWWBWWWWWWWWWWWWBBBWWWWW' +
            'WWWWWWWWWWWWWWWWWWWBWWWWWWWWWWWWWW',
            ys = runLengthEncoded(xs);

        console.log('From: ', show(xs));
        [ys, runLengthDecoded(ys)].forEach(
            x => console.log('  ->  ', show(x))
        )
    };

    // ----------------------GENERIC-----------------------

    // group :: [a] -> [[a]]
    const group = xs => {
        // A list of lists, each containing only equal elements,
        // such that the concatenation of these lists is xs.
        const go = xs =>
            0 < xs.length ? (() => {
                const
                    h = xs[0],
                    i = xs.findIndex(x => h !== x);
                return i !== -1 ? (
                    [xs.slice(0, i)].concat(go(xs.slice(i)))
                ) : [xs];
            })() : [];
        return go(xs);
    };

    // show :: a -> String
    const show = JSON.stringify;

    // MAIN ---
    return main();
})();

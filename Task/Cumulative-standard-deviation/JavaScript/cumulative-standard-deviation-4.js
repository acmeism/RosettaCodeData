(() => {
    'use strict';

    // ---------- CUMULATIVE STANDARD DEVIATION ----------

    // cumulativeStdDevns :: [Float] -> [Float]
    const cumulativeStdDevns = ns => {
        const go = ([s, q]) =>
            ([i, x]) => {
                const
                    _s = s + x,
                    _q = q + (x * x),
                    j = 1 + i;
                return [
                    [_s, _q],
                    Math.sqrt(
                        (_q / j) - Math.pow(_s / j, 2)
                    )
                ];
            };
        return mapAccumL(go)([0, 0])(ns)[1];
    };

    // ---------------------- TEST -----------------------
    const main = () =>
        showLog(
            cumulativeStdDevns([
                2, 4, 4, 4, 5, 5, 7, 9
            ])
        );

    // --------------------- GENERIC ---------------------

    // mapAccumL :: (acc -> x -> (acc, y)) -> acc -> [x] -> (acc, [y])
    const mapAccumL = f =>
        // A tuple of an accumulation and a list
        // obtained by a combined map and fold,
        // with accumulation from left to right.
        acc => xs => [...xs].reduce((a, x, i) => {
            const pair = f(a[0])([i, x]);
            return [pair[0], a[1].concat(pair[1])];
        }, [acc, []]);


    // showLog :: a -> IO ()
    const showLog = (...args) =>
        console.log(
            args
            .map(x => JSON.stringify(x, null, 2))
            .join(' -> ')
        );

    // MAIN ---
    return main();
})();

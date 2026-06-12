(() => {
    "use strict";

    // ------- N INSTANCES OF N AND ALL CONTIGUOUS -------

    // nnPeers :: Int -> [Int] -> Bool
    const nnPeers = n =>
        // True if xs contains exactly n instances of n
        // and the instances are all contiguous.
        xs => {
            const
                p = x => n === x,
                mbi = xs.findIndex(p);

            return -1 !== mbi ? (() => {
                const
                    rest = xs.slice(mbi),
                    sample = rest.slice(0, n);

                return n === sample.length && (
                    sample.every(p) && (
                        !rest.slice(n).some(p)
                    )
                );
            })() : false;
        };

    // ---------------------- TEST -----------------------
    const main = () => [
            [9, 3, 3, 3, 2, 1, 7, 8, 5],
            [5, 2, 9, 3, 3, 7, 8, 4, 1],
            [1, 4, 3, 6, 7, 3, 8, 3, 2],
            [1, 2, 3, 4, 5, 6, 7, 8, 9],
            [4, 6, 8, 7, 2, 3, 3, 3, 1]
        ]
        .map(
            xs => `${JSON.stringify(xs)} -> ${nnPeers(3)(xs)}`
        )
        .join("\n");

    return main();
})();

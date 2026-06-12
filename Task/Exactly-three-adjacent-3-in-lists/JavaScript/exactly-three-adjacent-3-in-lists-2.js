(() => {
    "use strict";

    // ------- 3 INSTANCES OF 3 AND ALL CONTIGUOUS ------

    // nnPeers :: Int -> [Int] -> Bool
    const nnPeers = n =>
        xs => {
            const go = ns =>
                ns.slice(0, n).every(x => n === x) || (
                    n < ns.length && go(ns.slice(1))
                );

            return go(xs);
        }

    const threeThree = nnPeers(3);

    // ---------------------- TEST -----------------------


    return [
        [9, 3, 3, 3, 2, 1, 7, 8, 5],
        [5, 2, 9, 3, 3, 7, 8, 4, 1],
        [1, 4, 3, 6, 7, 3, 8, 3, 2],
        [1, 2, 3, 4, 5, 6, 7, 8, 9],
        [4, 6, 8, 7, 2, 3, 3, 3, 1]
    ]
        .map(
            xs => `${JSON.stringify(xs)} -> ${threeThree(xs)}`
        )
        .join("\n");
})();

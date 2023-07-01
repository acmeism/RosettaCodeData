(() => {
    "use strict";

    // ----------- SPLIT ON CHARACTER CHANGES ------------
    const main = () =>
        group("gHHH5YY++///\\")
        .map(x => x.join(""))
        .join(", ");


    // --------------------- GENERIC ---------------------

    // group :: [a] -> [[a]]
    const group = xs =>
        // A list of lists, each containing only
        // elements equal under (===), such that the
        // concatenation of these lists is xs.
        groupBy(a => b => a === b)(xs);


    // groupBy :: (a -> a -> Bool) [a] -> [[a]]
    const groupBy = eqOp =>
        // A list of lists, each containing only elements
        // equal under the given equality operator,
        // such that the concatenation of these lists is xs.
        xs => 0 < xs.length ? (() => {
            const [h, ...t] = xs;
            const [groups, g] = t.reduce(
                ([gs, a], x) => eqOp(x)(a[0]) ? (
                    Tuple(gs)([...a, x])
                ) : Tuple([...gs, a])([x]),
                Tuple([])([h])
            );

            return [...groups, g];
        })() : [];


    // Tuple (,) :: a -> b -> (a, b)
    const Tuple = a =>
        b => ({
            type: "Tuple",
            "0": a,
            "1": b,
            length: 2,
            *[Symbol.iterator]() {
                for (const k in this) {
                    if (!isNaN(k)) {
                        yield this[k];
                    }
                }
            }
        });

    // MAIN ---
    return main();
})();

(() => {
    "use strict";

    // -- INSTANCE-SPECIFIC CHARACTER REPLACEMENT RULES --

    // # nthInstanceReplaced :: Dict Char [(Null | Char)] ->
    const nthInstanceReplaced = ruleMap =>
        // A string defined by replacements specified for
        // the nth instances of various characters.
        s => mapAccumL(
            (a, c) => c in a ? (() => {
                const ds = a[c];

                return Boolean(ds.length) ? [
                    Object.assign(a, {[c]: ds.slice(1)}),
                    ds[0] || c
                ] : [a, c];
            })() : [a, c]
        )(Object.assign({}, ruleMap))(
            [...s]
        )[1].join("");


    // ---------------------- TEST -----------------------
    const main = () =>
    // Instance-specific character replacement rules.
        nthInstanceReplaced({
            a: ["A", "B", null, "C", "D"],
            b: ["E"],
            r: [null, "F"]
        })(
            "abracadabra"
        );


    // --------------------- GENERIC ---------------------

    // mapAccumL :: (acc -> x -> (acc, y)) -> acc ->
    // [x] -> (acc, [y])
    const mapAccumL = f =>
    // A tuple of an accumulation and a list
    // obtained by a combined map and fold,
    // with accumulation from left to right.
        acc => xs => [...xs].reduce(
            ([a, bs], x) => second(
                v => [...bs, v]
            )(
                f(a, x)
            ),
            [acc, []]
        );


    // second :: (a -> b) -> ((c, a) -> (c, b))
    const second = f =>
    // A function over a simple value lifted
    // to a function over a tuple.
    // f (a, b) -> (a, f(b))
        ([x, y]) => [x, f(y)];


    // MAIN --
    return main();
})();

(() => {
    "use strict";

    // ----------- GREATEST ELEMENT OF A LIST ------------

    // maximumByMay :: (a -> a -> Ordering) ->
    // [a] -> Maybe a
    const maximumByMay = f =>
        // Nothing, if the list is empty,
        // or just the maximum value when compared
        // in terms of f.
        xs => Boolean(xs.length) ? (
            Just(xs.slice(1).reduce(
                (a, x) => 0 < f(a)(x) ? (
                    a
                ) : x,
                xs[0]
            ))
        ) : Nothing();


    // ---------------------- TEST -----------------------
    const main = () =>
        JSON.stringify(
            catMaybes([
                maximumByMay(
                    comparing(x => x.length)
                )([
                    "alpha", "beta", "gamma", "delta",
                    "epsilon", "zeta", "eta"
                ]),
                maximumByMay(comparing(x => x.length))([]),
                maximumByMay(comparing(x => x.n))([{
                    k: "Bejing",
                    n: 21.5
                }, {
                    k: "Delhi",
                    n: 16.7
                }, {
                    k: "Karachi",
                    n: 23.5
                }, {
                    k: "Lagos",
                    n: 16.0
                }, {
                    k: "Shanghai",
                    n: 24.3
                }, {
                    k: "Tokyo",
                    n: 13.2
                }])
            ]),
            null, 2
        );

    // --------------------- GENERIC ---------------------

    // Just :: a -> Maybe a
    const Just = x => ({
        type: "Maybe",
        Nothing: false,
        Just: x
    });


    // Nothing :: Maybe a
    const Nothing = () => ({
        type: "Maybe",
        Nothing: true
    });


    // catMaybes :: [Maybe a] -> [a]
    const catMaybes = mbs =>
        mbs.flatMap(
            m => m.Nothing ? (
                []
            ) : [m.Just]
        );


    // comparing :: (a -> b) -> (a -> a -> Ordering)
    const comparing = f =>
        x => y => {
            const
                a = f(x),
                b = f(y);

            return a < b ? -1 : (a > b ? 1 : 0);
        };

    // MAIN ---
    return main();
})();

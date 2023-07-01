(() => {
    "use strict";

    // vanEck :: Int -> [Int]
    const vanEck = n =>
        // First n terms of the vanEck series.
        [0].concat(mapAccumL(
            ([x, seen]) => i => {
                const
                    prev = seen[x],
                    v = Boolean(prev) ? (
                        i - prev
                    ) : 0;

                return [
                    [v, (seen[x] = i, seen)], v
                ];
            })(
            [0, {}]
        )(
            enumFromTo(1)(n - 1)
        )[1]);


    // ----------------------- TEST ------------------------
    const main = () =>
        fTable(
            "Terms of the VanEck series:\n"
        )(
            n => `${str(n - 10)}-${str(n)}`
        )(
            xs => JSON.stringify(xs.slice(-10))
        )(
            vanEck
        )([10, 1000, 10000]);


    // ----------------- GENERIC FUNCTIONS -----------------

    // enumFromTo :: Int -> Int -> [Int]
    const enumFromTo = m =>
        n => Array.from({
            length: 1 + n - m
        }, (_, i) => m + i);


    // fTable :: String -> (a -> String) ->
    // (b -> String) -> (a -> b) -> [a] -> String
    const fTable = s =>
        // Heading -> x display function ->
        //           fx display function ->
        //    f -> values -> tabular string
        xShow => fxShow => f => xs => {
            const
                ys = xs.map(xShow),
                w = Math.max(...ys.map(y => [...y].length)),
                table = zipWith(
                    a => b => `${a.padStart(w, " ")} -> ${b}`
                )(ys)(
                    xs.map(x => fxShow(f(x)))
                ).join("\n");

            return `${s}\n${table}`;
        };


    // mapAccumL :: (acc -> x -> (acc, y)) -> acc ->
    // [x] -> (acc, [y])
    const mapAccumL = f =>
        // A tuple of an accumulation and a list
        // obtained by a combined map and fold,
        // with accumulation from left to right.
        acc => xs => [...xs].reduce(
            ([a, bs], x) => second(
                v => bs.concat(v)
            )(
                f(a)(x)
            ),
            [acc, []]
        );


    // second :: (a -> b) -> ((c, a) -> (c, b))
    const second = f =>
        // A function over a simple value lifted
        // to a function over a tuple.
        // f (a, b) -> (a, f(b))
        ([x, y]) => [x, f(y)];


    // str :: a -> String
    const str = x => x.toString();


    // zipWith :: (a -> b -> c) -> [a] -> [b] -> [c]
    const zipWith = f =>
        // A list constructed by zipping with a
        // custom function, rather than with the
        // default tuple constructor.
        xs => ys => xs.map(
            (x, i) => f(x)(ys[i])
        ).slice(
            0, Math.min(xs.length, ys.length)
        );

    // MAIN ---
    return main();
})();

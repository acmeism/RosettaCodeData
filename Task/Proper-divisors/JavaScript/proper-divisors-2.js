(() => {
    'use strict';

    // properDivisors :: Int -> [Int]
    const properDivisors = n => {
        // The integer divisors of n, excluding n itself.
        const
            rRoot = Math.sqrt(n),
            intRoot = Math.floor(rRoot),
            blnPerfectSquare = rRoot === intRoot,
            lows = enumFromTo(1)(intRoot)
            .filter(x => 0 === (n % x));

        // For perfect squares, we can drop
        // the head of the 'highs' list
        return lows.concat(lows
                .map(x => n / x)
                .reverse()
                .slice(blnPerfectSquare | 0)
            )
            .slice(0, -1); // except n itself
    };


    // ------------------------TESTS-----------------------
    // main :: IO ()
    const main = () =>
        console.log([
            fTable('Proper divisors of [1..10]:')(str)(
                JSON.stringify
            )(properDivisors)(enumFromTo(1)(10)),
            '',
            'Example of maximum divisor count in the range [1..20000]:',
            '    ' + maximumBy(comparing(snd))(
                enumFromTo(1)(20000).map(
                    n => [n, properDivisors(n).length]
                )
            ).join(' has ') + ' proper divisors.'
        ].join('\n'));


    // -----------------GENERIC FUNCTIONS------------------

    // comparing :: (a -> b) -> (a -> a -> Ordering)
    const comparing = f =>
        x => y => {
            const
                a = f(x),
                b = f(y);
            return a < b ? -1 : (a > b ? 1 : 0);
        };

    // enumFromTo :: Int -> Int -> [Int]
    const enumFromTo = m => n =>
        Array.from({
            length: 1 + n - m
        }, (_, i) => m + i);

    // fTable :: String -> (a -> String) -> (b -> String)
    //                      -> (a -> b) -> [a] -> String
    const fTable = s => xShow => fxShow => f => xs => {
        // Heading -> x display function ->
        //           fx display function ->
        //    f -> values -> tabular string
        const
            ys = xs.map(xShow),
            w = Math.max(...ys.map(x => x.length));
        return s + '\n' + zipWith(
            a => b => a.padStart(w, ' ') + ' -> ' + b
        )(ys)(
            xs.map(x => fxShow(f(x)))
        ).join('\n');
    };

    // maximumBy :: (a -> a -> Ordering) -> [a] -> a
    const maximumBy = f => xs =>
        0 < xs.length ? (
            xs.slice(1)
            .reduce((a, x) => 0 < f(x)(a) ? x : a, xs[0])
        ) : undefined;

    // snd :: (a, b) -> b
    const snd = tpl => tpl[1];

    // str :: a -> String
    const str = x => x.toString();

    // until :: (a -> Bool) -> (a -> a) -> a -> a
    const until = p => f => x => {
        let v = x;
        while (!p(v)) v = f(v);
        return v;
    };

    // zipWith :: (a -> b -> c) -> [a] -> [b] -> [c]
    const zipWith = f => xs => ys => {
        const
            lng = Math.min(xs.length, xs.length),
            as = xs.slice(0, lng),
            bs = ys.slice(0, lng);
        return Array.from({
            length: lng
        }, (_, i) => f(as[i])(
            bs[i]
        ));
    };

    // MAIN ---
    return main();
})();

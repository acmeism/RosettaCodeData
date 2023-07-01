(() => {
    'use strict';

    const main = () => {

        // sparkLine :: [Num] -> String
        const sparkLine = xs => {
            const hist = dataBins(8)(xs);
            return unlines([
                concat(map(
                    i => '▁▂▃▄▅▆▇█' [i],
                    hist.indexes
                )),
                unwords(xs),
                [
                    'Min: ' + hist.min,
                    'Mean: ' + hist.mean.toFixed(2),
                    'Median: ' + hist.median,
                    'Max: ' + hist.max,
                ].join('\t'),
                ''
            ]);
        };


        // dataBins :: Int -> [Num] ->
        //      {indexes:: [Int], min:: Float, max:: Float,
        //        range :: Float, lbounds :: [Float]}
        const dataBins = intBins => xs => {
            const
                iLast = intBins - 1,
                ys = sort(xs),
                mn = ys[0],
                mx = last(ys),
                rng = mx - mn,
                w = rng / intBins,
                lng = xs.length,
                mid = lng / 2,
                lbounds = map(
                    i => mn + (w * i),
                    enumFromTo(1, iLast)
                );
            return {
                indexes: map(
                    x => {
                        const mb = findIndex(b => b > x, lbounds);
                        return mb.Nothing ? (
                            iLast
                        ) : mb.Just;
                    },
                    xs
                ),
                lbounds: lbounds,
                min: mn,
                median: even(lng) ? (
                    sum([ys[mid - 1], ys[mid]]) / 2
                ) : ys[Math.floor(mid)],
                mean: sum(xs) / lng,
                max: mx,
                range: rng
            };
        };

        // numbersFromString :: String -> [Float]
        const numbersFromString = s =>
            map(x => parseFloat(x, 10),
                s.split(/[,\s]+/)
            );

        return unlines(map(
            compose(sparkLine, numbersFromString),
            [
                '0, 1, 19, 20',
                '0, 999, 4000, 4999, 7000, 7999',
                '1 2 3 4 5 6 7 8 7 6 5 4 3 2 1',
                '1.5, 0.5 3.5, 2.5 5.5, 4.5 7.5, 6.5'
            ]
        ));
    };

    // GENERIC FUNCTIONS ----------------------------

    // Just :: a -> Maybe a
    const Just = x => ({
        type: 'Maybe',
        Nothing: false,
        Just: x
    });

    // Nothing :: Maybe a
    const Nothing = () => ({
        type: 'Maybe',
        Nothing: true,
    });

    // compose (<<<) :: (b -> c) -> (a -> b) -> a -> c
    const compose = (f, g) => x => f(g(x));

    // concat :: [[a]] -> [a]
    // concat :: [String] -> String
    const concat = xs =>
        0 < xs.length ? (() => {
            const unit = 'string' !== typeof xs[0] ? (
                []
            ) : '';
            return unit.concat.apply(unit, xs);
        })() : [];


    // enumFromTo :: (Int, Int) -> [Int]
    const enumFromTo = (m, n) =>
        Array.from({
            length: 1 + n - m
        }, (_, i) => m + i);

    // even :: Int -> Bool
    const even = n => 0 === n % 2;

    // last :: [a] -> a
    const last = xs =>
        0 < xs.length ? xs.slice(-1)[0] : undefined;

    // map :: (a -> b) -> [a] -> [b]
    const map = (f, xs) =>
        (Array.isArray(xs) ? (
            xs
        ) : xs.split('')).map(f);

    // sort :: Ord a => [a] -> [a]
    const sort = xs => xs.slice()
        .sort((a, b) => a < b ? -1 : (a > b ? 1 : 0));


    // findIndex :: (a -> Bool) -> [a] -> Maybe Int
    const findIndex = (p, xs) => {
        const
            i = (
                'string' !== typeof xs ? (
                    xs
                ) : xs.split('')
            ).findIndex(p);
        return -1 !== i ? (
            Just(i)
        ) : Nothing();
    };

    // sum :: [Num] -> Num
    const sum = xs => xs.reduce((a, x) => a + x, 0);

    // unlines :: [String] -> String
    const unlines = xs => xs.join('\n');

    // unwords :: [String] -> String
    const unwords = xs => xs.join(' ');

    // MAIN ---
    return main();
})();

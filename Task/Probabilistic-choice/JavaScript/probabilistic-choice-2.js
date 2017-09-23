(() => {
    'use strict';

    // GENERIC FUNCTIONS -----------------------------------------------------

    // transpose :: [[a]] -> [[a]]
    const transpose = xs =>
        xs[0].map((_, iCol) => xs.map(row => row[iCol]));

    // justifyLeft :: Int -> Char -> Text -> Text
    const justifyLeft = (n, cFiller, strText) =>
        n > strText.length ? (
            (strText + cFiller.repeat(n))
            .substr(0, n)
        ) : strText;

    // 2 or more arguments
    // curry :: Function -> Function
    const curry = (f, ...args) => {
        const go = xs => xs.length >= f.length ? (f.apply(null, xs)) :
            function () {
                return go(xs.concat([].slice.apply(arguments)));
            };
        return go([].slice.call(args, 1));
    };

    // zipWith :: (a -> b -> c) -> [a] -> [b] -> [c]
    const zipWith = (f, xs, ys) => {
        const ny = ys.length;
        return (xs.length <= ny ? xs : xs.slice(0, ny))
            .map((x, i) => f(x, ys[i]));
    };

    // subtract :: (Num a) => a -> a -> a
    const subtract = (x, y) => y - x;

    // scanl1 :: (a -> a -> a) -> [a] -> [a]
    const scanl1 = (f, xs) =>
        xs.length > 0 ? scanl(f, xs[0], xs.slice(1)) : [];

    // scanl :: (b -> a -> b) -> b -> [a] -> [b]
    const scanl = (f, startValue, xs) =>
        xs.reduce((a, x) => {
            const v = f(a.acc, x);
            return {
                acc: v,
                scan: a.scan.concat(v)
            };
        }, {
            acc: startValue,
            scan: [startValue]
        })
        .scan;

    // unwords :: [String] -> String
    const unwords = xs => xs.join(' ');


    // PROBABILISTIC CHOICE --------------------------------------------------

    // samples :: Int -> Int -> [Float]
    const samples = n =>
        Array.from({
            length: n
        }, Math.random);

    // thresholds :: Float
    const thresholds = scanl1(
            (a, b) => a + b, [5, 6, 7, 8, 9, 10, 11].map(x => 1 / x)
        )
        .concat(1);

    // expected :: Float -> Float
    const expected = limits =>
        limits.map((x, i, xs) => i > 0 ? (x - xs[i - 1]) : x);

    // dataBinCounts :: [Float] -> [Float] -> [Int]
    const dataBinCounts = (thresholds, samples) => {
        const
            lng = samples.length,
            xs = thresholds
            .map(x => lng - samples.filter(v => v > x)
                .length);
        return zipWith(subtract, [0].concat(xs), xs.concat(lng));
    };

    // intSamples :: Integer
    const intSamples = 1000000;

    // aligned :: a -> String
    const aligned = x => justifyLeft(12, ' ', isNaN(x) ? x : x.toFixed(7));

    return transpose([
            ['', 'Aleph', 'Beit', 'Gimel', 'Dalet', 'He', 'Vav', 'Zayin', 'Chet']
            .map(curry(justifyLeft)(7, ' ')),

            ['Expected'].concat(expected(thresholds))
            .map(aligned),

            ['Observed'].concat(dataBinCounts(thresholds, samples(intSamples))
                .map(x => x / intSamples))
            .map(aligned)
        ])
        .map(unwords)
        .join('\n');
})();

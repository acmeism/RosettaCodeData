(() => {
    'use strict';

    // shuffleCycleLength :: Int -> Int
    const shuffleCycleLength = deckSize =>
        firstCycle(shuffle, range(1, deckSize))
        .all.length;

    // shuffle :: [a] -> [a]
    const shuffle = xs =>
        concat(zip.apply(null, splitAt(div(length(xs), 2), xs)));

    // firstycle :: Eq a => (a -> a) -> a -> [a]
    const firstCycle = (f, x) =>
        until(
            m => EqArray(x, m.current),
            m => {
                const fx = f(m.current);
                return {
                    current: fx,
                    all: m.all.concat([fx])
                };
            }, {
                current: f(x),
                all: [x]
            }
        );

    // Two arrays equal ?
    // EqArray :: [a] -> [b] -> Bool
    const EqArray = (xs, ys) => {
        const [nx, ny] = [xs.length, ys.length];
        return nx === ny ? (
            nx > 0 ? (
                xs[0] === ys[0] && EqArray(xs.slice(1), ys.slice(1))
            ) : true
        ) : false;
    };

    // GENERIC FUNCTIONS

    // zip :: [a] -> [b] -> [(a,b)]
    const zip = (xs, ys) =>
        xs.slice(0, Math.min(xs.length, ys.length))
        .map((x, i) => [x, ys[i]]);

    // concat :: [[a]] -> [a]
    const concat = xs => [].concat.apply([], xs);

    // splitAt :: Int -> [a] -> ([a],[a])
    const splitAt = (n, xs) => [xs.slice(0, n), xs.slice(n)];

    // div :: Num -> Num -> Int
    const div = (x, y) => Math.floor(x / y);

    // until :: (a -> Bool) -> (a -> a) -> a -> a
    const until = (p, f, x) => {
        const go = x => p(x) ? x : go(f(x));
        return go(x);
    }

    // range :: Int -> Int -> [Int]
    const range = (m, n) =>
        Array.from({
            length: Math.floor(n - m) + 1
        }, (_, i) => m + i);

    // length :: [a] -> Int
    // length :: Text -> Int
    const length = xs => xs.length;

    // maximumBy :: (a -> a -> Ordering) -> [a] -> a
    const maximumBy = (f, xs) =>
        xs.reduce((a, x) => a === undefined ? x : (
            f(x, a) > 0 ? x : a
        ), undefined);

    // transpose :: [[a]] -> [[a]]
    const transpose = xs =>
        xs[0].map((_, iCol) => xs.map((row) => row[iCol]));

    // show :: a -> String
    const show = x => JSON.stringify(x, null, 2);

    // replicateS :: Int -> String -> String
    const replicateS = (n, s) => {
        let v = s,
            o = '';
        if (n < 1) return o;
        while (n > 1) {
            if (n & 1) o = o.concat(v);
            n >>= 1;
            v = v.concat(v);
        }
        return o.concat(v);
    };

    // justifyRight :: Int -> Char -> Text -> Text
    const justifyRight = (n, cFiller, strText) =>
        n > strText.length ? (
            (replicateS(n, cFiller) + strText)
            .slice(-n)
        ) : strText;

    // TEST
    return transpose(transpose([
                ['Deck', 'Shuffles']
            ].concat(
                [8, 24, 52, 100, 1020, 1024, 10000]
                .map(n => [n.toString(), shuffleCycleLength(n)
                    .toString()
                ])))
            .map(col => { // Right-justified number columns
                const width = length(
                    maximumBy((a, b) => length(a) - length(b), col)
                ) + 2;

                return col.map(x => justifyRight(width, ' ', x));
            }))
        .map(row => row.join(''))
        .join('\n');
})();

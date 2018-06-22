(() => {

    // multTable :: Int -> Int -> [[String]]
    const multTable = (m, n) => {
        const xs = enumFromToInt(m, n);
        return [
            ['x', ...xs],
            ...concatMap(
                x => [
                    [x, ...concatMap(
                        y => y < x ? [''] : [x * y],
                        xs
                    )]
                ],
                xs
            )
        ];
    };

    // main :: () -> IO String
    const main = () => {
        return wikiTable(
            multTable(1, 12), true,
            'text-align:center;width:33em;height:33em;table-layout:fixed;'
        );
    };

    // GENERIC FUNCTIONS -----------------------------------------------------

    // Tuple (,) :: a -> b -> (a, b)
    const Tuple = (a, b) => ({
        type: 'Tuple',
        '0': a,
        '1': b
    });

    // Size of space -> filler Char -> String -> Centered String
    // center :: Int -> Char -> String -> String
    const center = (n, c, s) => {
        const
            qr = quotRem(n - s.length, 2),
            q = qr[0];
        return concat(concat([replicate(q, c), s, replicate(q + qr[1], c)]));
    };

    // concat :: [[a]] -> [a]
    // concat :: [String] -> String
    const concat = xs =>
        xs.length > 0 ? (() => {
            const unit = typeof xs[0] === 'string' ? '' : [];
            return unit.concat.apply(unit, xs);
        })() : [];

    // concatMap :: (a -> [b]) -> [a] -> [b]
    const concatMap = (f, xs) => [].concat.apply([], xs.map(f));

    // enumFromToInt :: Int -> Int -> [Int]
    const enumFromToInt = (m, n) =>
        n >= m ? Array.from({
            length: Math.floor(n - m) + 1
        }, (_, i) => m + i) : [];

    // map :: (a -> b) -> [a] -> [b]
    const map = (f, xs) => xs.map(f);

    // quotRem :: Int -> Int -> (Int, Int)
    const quotRem = (m, n) => Tuple(Math.floor(m / n), m % n);

    // replicate :: Int -> a -> [a]
    const replicate = (n, x) =>
        Array.from({
            length: n
        }, () => x);

    // FORMATTING -------------------------------------------------------------

    // wikiTable :: [[a]] -> Bool -> String -> String
    const wikiTable = (rows, blnHeader, style) =>
        '{| class="wikitable" ' + (
            style ? 'style="' + style + '"' : ''
        ) + rows.map((row, i) => {
            const dlm = ((blnHeader && !i) ? '!' : '|');
            return '\n|-\n' + dlm + ' ' + row.map(v =>
                    typeof v !== 'undefined' ? v : ' '
                )
                .join(' ' + dlm + dlm + ' ');
        })
        .join('') + '\n|}';

    // MAIN ------------------------------------------------------------------
    return main();
})();

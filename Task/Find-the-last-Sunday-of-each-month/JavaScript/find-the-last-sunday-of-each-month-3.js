(() => {
    'use strict'

    // MAIN -----------------------------------------------
    // main :: IO ()
    const main = () =>
        console.log(unlines(
            map(
                compose(
                    intercalate('\t'),
                    map(isoDateString)
                )
            )(
                transpose(
                    map(lastWeekDaysOfYear(days.sunday))(
                        enumFromTo(2019)(2022)
                    )
                )
            )
        ));

    // WEEKDAYS -------------------------------------------

    // lastWeekDaysOfYear :: Int -> Int -> [Date]
    const lastWeekDaysOfYear = iWeekDay =>
        y => map((d, m) =>
            new Date(Date.UTC(
                y, m, d - ((new Date(Date.UTC(y, m, d))
                    .getDay() + (7 - iWeekDay)) % 7))))([
            31,
            0 === y % 4 && 0 !== y % 100 || 0 === y % 400 ? 29 : 28,
            31, 30, 31, 30, 31, 31, 30, 31, 30, 31
        ]);

    const days = {
        sunday: 0,
        monday: 1,
        tuesday: 2,
        wednesday: 3,
        thursday: 4,
        friday: 5,
        saturday: 6
    };

    // GENERIC FUNCTIONS-----------------------------------

    // compose (<<<) :: (b -> c) -> (a -> b) -> a -> c
    const compose = (...fs) =>
        x => fs.reduceRight((a, f) => f(a), x);

    // enumFromTo :: Int -> Int -> [Int]
    const enumFromTo = m => n =>
        Array.from({
            length: 1 + n - m
        }, (_, i) => m + i);

    // intercalate :: String -> [String] -> String
    const intercalate = s => xs =>
        xs.join(s);

    // isoDateString :: Date -> String
    const isoDateString = dte =>
        dte.toISOString()
        .substr(0, 10);

    // map :: (a -> b) -> [a] -> [b]
    const map = f => xs =>
        (Array.isArray(xs) ? (
            xs
        ) : xs.split('')).map(f);

    // If some of the rows are shorter than the following rows,
    // their elements are skipped:
    // > transpose [[10,11],[20],[],[30,31,32]] == [[10,20,30],[11,31],[32]]

    // transpose :: [[a]] -> [[a]]
    const transpose = xss => {
        const go = xss =>
            0 < xss.length ? (() => {
                const
                    h = xss[0],
                    t = xss.slice(1);
                return 0 < h.length ? (
                    [
                        [h[0]].concat(t.reduce(
                            (a, xs) => a.concat(
                                0 < xs.length ? (
                                    [xs[0]]
                                ) : []
                            ),
                            []
                        ))
                    ].concat(go([h.slice(1)].concat(
                        t.map(xs => xs.slice(1))
                    )))
                ) : go(t);
            })() : [];
        return go(xss);
    };

    // unlines :: [String] -> String
    const unlines = xs => xs.join('\n');

    // MAIN ---
    return main();
})();

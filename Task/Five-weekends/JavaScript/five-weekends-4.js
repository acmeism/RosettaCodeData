(() => {
    // longMonthsStartingFriday :: Int -> [Int]
    const longMonthsStartingFriday = y =>
        filter(m => (new Date(Date.UTC(y, m, 1)))
            .getDay() === 5, [0, 2, 4, 6, 7, 9, 11]);

    // Years -> YearMonths
    // fullMonths :: [Int] -> [String]
    const fullMonths = xs =>
        foldl((a, y) => a.concat(
            map(m => `${y.toString()} ${[
                            'January', '', 'March', '', 'May', '',
                            'July', 'August', '', 'October', '', 'December'
                        ][m]}`, longMonthsStartingFriday(y))
        ), [], xs);

    // leanYears :: [Int] -> [Int]
    const leanYears = years =>
        filter(y => longMonthsStartingFriday(y)
            .length === 0, years);

    // GENERIC ----------------------------------------------------------------

    // A list of functions applied to a list of arguments
    // <*> :: [(a -> b)] -> [a] -> [b]
    const ap = (fs, xs) => //
        [].concat.apply([], fs.map(f => //
            [].concat.apply([], xs.map(x => [f(x)]))));

    // enumFromTo :: Int -> Int -> [Int]
    const enumFromTo = (m, n) =>
        Array.from({
            length: Math.floor(n - m) + 1
        }, (_, i) => m + i);

    // filter :: (a -> Bool) -> [a] -> [a]
    const filter = (f, xs) => xs.filter(f);

    // foldl :: (b -> a -> b) -> b -> [a] -> b
    const foldl = (f, a, xs) => xs.reduce(f, a);

    // map :: (a -> b) -> [a] -> [b]
    const map = (f, xs) => xs.map(f);

    // show :: a -> String
    const show = x => JSON.stringify(x, null, 2);


    // TEST -------------------------------------------------------------------
    const [lstFullMonths, lstLeanYears] = ap(
        [fullMonths, leanYears], [enumFromTo(1900, 2100)]
    );

    return show({
        number: lstFullMonths.length,
        firstFive: lstFullMonths.slice(0, 5),
        lastFive: lstFullMonths.slice(-5),
        leanYearCount: lstLeanYears.length
    });
})();

(() => {
    'use strict'

    // lastWeekDaysOfYear :: Int -> Int -> [Date]
    const lastWeekDaysOfYear = (iWeekDay, y) => [
            31,
            0 === y % 4 && 0 !== y % 100 || 0 === y % 400 ? 29 : 28,
            31, 30, 31, 30, 31, 31, 30, 31, 30, 31
        ]
        .map((d, m) =>
            new Date(Date.UTC(
                y, m, d - ((new Date(Date.UTC(y, m, d))
                    .getDay() + (7 - iWeekDay)) % 7))));

    const days = {
        sunday: 0,
        monday: 1,
        tuesday: 2,
        wednesday: 3,
        thursday: 4,
        friday: 5,
        saturday: 6
    };

    // GENERIC FUNCTIONS

    // curry :: ((a, b) -> c) -> a -> b -> c
    const curry = f => a => b => f(a, b);

    // isoDateString :: Date -> String
    const isoDateString = dte =>
        dte.toISOString()
        .substr(0, 10);

    // range :: Int -> Int -> [Int]
    const range = (m, n) =>
        Array.from({
            length: Math.floor(n - m) + 1
        }, (_, i) => m + i);

    // transpose :: [[a]] -> [[a]]
    const transpose = lst =>
        lst[0].map((_, iCol) =>
            lst.map(row => row[iCol]));

    // TEST
    return transpose(
            range(2015, 2019)
            .map(curry(lastWeekDaysOfYear)(days.friday))
        )
        .map(row => row
            .map(isoDateString)
            .join('\t'))
        .join('\n');
})();

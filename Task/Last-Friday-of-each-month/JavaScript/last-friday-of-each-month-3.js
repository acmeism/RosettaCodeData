(() => {
    "use strict";

    // ------------ LAST FRIDAY OF EACH MONTH ------------

    // lastWeekDaysOfYear :: Int -> Int -> [Date]
    const lastWeekDaysOfYear = iWeekDay =>
        y => {
            const isLeap = n => (
                (0 === n % 4) && (0 !== n % 100)) || (
                0 === y % 400
            );

            return [
                    31, isLeap(y) ? 29 : 28,
                    31, 30, 31, 30, 31, 31, 30, 31, 30, 31
                ]
                .map((d, m) =>
                    new Date(Date.UTC(
                        y, m, d - ((
                            new Date(Date.UTC(
                                y, m, d
                            ))
                            .getDay() + (7 - iWeekDay)
                        ) % 7)
                    ))
                );
        };


    const days = {
        sunday: 0,
        monday: 1,
        tuesday: 2,
        wednesday: 3,
        thursday: 4,
        friday: 5,
        saturday: 6
    };

    // ---------------------- TEST -----------------------
    const main = () =>
        transpose(
            enumFromTo(2015)(2019)
            .map(lastWeekDaysOfYear(days.friday))
        )
        .map(
            row => row.map(isoDateString).join("\t")
        )
        .join("\n");


    // ---------------- GENERIC FUNCTIONS ----------------

    // enumFromTo :: Int -> Int -> [Int]
    const enumFromTo = m =>
        n => Array.from({
            length: 1 + n - m
        }, (_, i) => m + i);


    // isoDateString :: Date -> String
    const isoDateString = dte =>
        dte.toISOString()
        .substr(0, 10);


    // transpose :: [[a]] -> [[a]]
    const transpose = rows =>
        // The columns of the input transposed
        // into new rows.
        0 < rows.length ? rows[0].map(
            (x, i) => rows.flatMap(
                v => v[i]
            )
        ) : [];

    // MAIN ---
    return main();
})();

(function () {
    'use strict';

    // lastFridaysOfYear :: Int -> [Date]
    function lastFridaysOfYear(y) {
        return lastWeekDaysOfYear(y, days.friday);
    }

    // lastWeekDaysOfYear :: Int -> Int -> [Date]
    function lastWeekDaysOfYear(y, iWeekDay) {
        return [
                31,
                0 === y % 4 && 0 !== y % 100 || 0 === y % 400 ? 29 : 28,
                31, 30, 31, 30, 31, 31, 30, 31, 30, 31
            ]
            .map(function (d, m) {
                var dte = new Date(Date.UTC(y, m, d));

                return new Date(Date.UTC(
                    y, m, d - (
                        (dte.getDay() + (7 - iWeekDay)) % 7
                    )
                ));
            });
    }

    // isoDateString :: Date -> String
    function isoDateString(dte) {
        return dte.toISOString()
            .substr(0, 10);
    }

    // range :: Int -> Int -> [Int]
    function range(m, n) {
        return Array.apply(null, Array(n - m + 1))
            .map(function (x, i) {
                return m + i;
            });
    }

    // transpose :: [[a]] -> [[a]]
    function transpose(lst) {
        return lst[0].map(function (_, iCol) {
            return lst.map(function (row) {
                return row[iCol];
            });
        });
    }

    var days = {
        sunday: 0,
        monday: 1,
        tuesday: 2,
        wednesday: 3,
        thursday: 4,
        friday: 5,
        saturday: 6
    }

    // TEST
    return transpose(
            range(2012, 2016)
            .map(lastFridaysOfYear)
        )
        .map(function (row) {
            return row
                .map(isoDateString)
                .join('\t');
        })
        .join('\n');
})();

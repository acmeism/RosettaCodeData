(function () {
    'use strict';


    // longMonthsStartingFriday :: Int -> Int
    function longMonthsStartingFriday(y) {
        return [0, 2, 4, 6, 7, 9, 11]
            .filter(function (m) {
                return (new Date(Date.UTC(y, m, 1)))
                    .getDay() === 5;
            });
    }


    // range :: Int -> Int -> [Int]
    function range(m, n) {
        return Array.apply(null, Array(n - m + 1))
            .map(function (x, i) {
                return m + i;
            });
    }

    var lstNames = [
            'January', '', 'March', '', 'May', '',
            'July', 'August', '', 'October', '', 'December'
        ],

        lstYears = range(1900, 2100),

        lstFullMonths = lstYears
        .reduce(function (a, y) {
            var strYear = y.toString();

            return a.concat(
                longMonthsStartingFriday(y)
                .map(function (m) {
                    return strYear + ' ' + lstNames[m];
                })
            );
        }, []),

        lstLeanYears = lstYears
        .filter(function (y) {
            return longMonthsStartingFriday(y)
                .length === 0;
        });

    return JSON.stringify({
            number: lstFullMonths.length,
            firstFive: lstFullMonths.slice(0, 5),
            lastFive: lstFullMonths.slice(-5),
            leanYearCount: lstLeanYears.length
        },
        null, 2
    );

})();

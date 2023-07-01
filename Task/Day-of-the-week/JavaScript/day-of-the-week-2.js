(function () {
    'use strict';

    // isXmasSunday :: Integer -> Bool
    function isXmasSunday(year) {
        return (new Date(year, 11, 25))
            .getDay() === 0;
    }

    // range :: Int -> Int -> [Int]
    function range(m, n) {
        return Array.apply(null, Array(n - m + 1))
            .map(function (_, i) {
                return m + i;
            });
    }

    return range(2008, 2121)
        .filter(isXmasSunday);

})();

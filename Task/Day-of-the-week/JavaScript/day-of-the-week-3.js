(() => {
    'use strict';

    // xmasIsSunday :: Integer -> Bool
    const xmasIsSunday = year => (new Date(year, 11, 25))
            .getDay() === 0;

    // range :: Int -> Int -> [Int]
    const range = (m, n) =>
        Array.from({
            length: Math.floor(n - m) + 1
        }, (_, i) => m + i);



    return range(2008, 2121)
        .filter(xmasIsSunday);

})();

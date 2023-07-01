(() => {
    "use strict";

    // main :: IO ()
    const main = () => {
        const
            xs = enumFromTo(2008)(2121)
            .filter(xmasIsSunday);

        return (
            console.log(xs),
            xs
        );
    };


    // xmasIsSunday :: Int -> Bool
    const xmasIsSunday = year =>
        (new Date(year, 11, 25))
        .getDay() === 0;


    // enumFromTo :: Int -> Int -> [Int]
    const enumFromTo = m =>
        n => Array.from({
            length: 1 + n - m
        }, (_, i) => m + i);

    // MAIN ---
    return main();
})();

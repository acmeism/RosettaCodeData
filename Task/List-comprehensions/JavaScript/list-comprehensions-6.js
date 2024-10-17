(() => {
    "use strict";

    // [(x, y, z) | x <- [1..n], y <- [x..n], z <- [y..n], x ^ 2 + y ^ 2 == z ^ 2]

    const main = () => {
        const n = 20;

        return enumFromTo(1)(n).flatMap(
            x => enumFromTo(x)(n).flatMap(
                y => enumFromTo(y)(n).flatMap(
                    z => x ** 2 + y ** 2 === z ** 2
                        ? [[x, y, z]]
                        : []
                )
            )
        );
    };



    // --------------------- GENERIC ---------------------

    // enumFromTo :: Int -> Int -> [Int]
    const enumFromTo = m =>
        // Enumeration of the integers from m to n.
        n => Array.from(
            { length: 1 + n - m },
            (_, i) => m + i
        );


    // MAIN ---
    return JSON.stringify(main());
})();

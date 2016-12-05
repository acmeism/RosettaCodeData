(() => {
    'use strict';

    // sparkLine :: [Num] -> String
    let sparkLine = xs => {
            let min = minimumBy(numericOrdering, xs),
                max = maximumBy(numericOrdering, xs),
                range = max - min;

            return xs.map(x => ((x - min) * 7) / range)
                .map(
                    n => (n >= 0 && n < 8) ? '▁▂▃▄▅▆▇█'
                    .split('')[Math.round(n)] : undefined
                ).join('');
        },

        // maximumBy :: (a -> a -> Ordering) -> [a] -> a
        maximumBy = (f, xs) =>
            xs.reduce((a, x) =>
                a === undefined ? x : (
                    f(x, a) > 0 ? x : a
                ),
                undefined
            ),


        // minimumBy :: (a -> a -> Ordering) -> [a] -> a
        minimumBy = (f, xs) =>
            xs.reduce((a, x) =>
                a === undefined ? x : (
                    f(x, a) < 0 ? x : a
                ),
                undefined
            ),

        numericOrdering = (a, b) => a < b ? -1 : (a > b ? 1 : 0);

    // TEST

    return ["1 2 3 4 5 6 7 8 7 6 5 4 3 2 1",
        "1.5, 0.5 3.5, 2.5 5.5, 4.5 7.5, 6.5",
        "3 2 1 0 -1 -2 -3 -4 -3 -2 -1 0 1 2 3",
        "-1000 100 1000 500 200 -400 -700 621 -189 3"
    ].map(
        s => s.split(/[,\s]+/)
        .map(x => parseFloat(x, 10))
    ).map(sparkLine);

})();

(() => {
    'use strict';

    // pascal :: Int -> [[Int]]
    let pascal = n =>
            range(1, n - 1)
            .reduce(a => {
                let lstPreviousRow = a.slice(-1)[0];

                return a
                    .concat([zipWith((a, b) => a + b,
                        [0].concat(lstPreviousRow),
                        lstPreviousRow.concat(0)
                    )]);
            }, [
                [1]
            ]);

    // GENERIC FUNCTIONS

    // Int -> Int -> Maybe Int -> [Int]
    let range = (m, n, step) => {
                let d = (step || 1) * (n >= m ? 1 : -1);
                return Array.from({
                    length: Math.floor((n - m) / d) + 1
                }, (_, i) => m + (i * d));
            },

        // zipWith :: (a -> b -> c) -> [a] -> [b] -> [c]
        zipWith = (f, xs, ys) =>
            xs.length === ys.length ? (
                xs.map((x, i) => f(x, ys[i]))
            ) : undefined;

    // TEST
    return pascal(7)
        .reduceRight((a, x) => {
            let strIndent = a.indent;

            return {
                rows: strIndent + x
                    .map(n => ('    ' + n).slice(-4))
                    .join('') + '\n' + a.rows,
                indent: strIndent + '  '
            };
        }, {
            rows: '',
            indent: ''
        }).rows;
})();

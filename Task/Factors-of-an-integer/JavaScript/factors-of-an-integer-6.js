(function (lstTest) {
    'use strict';

    // INTEGER FACTORS

    // integerFactors :: Int -> [Int]
    let integerFactors = (n) => {
            let rRoot = Math.sqrt(n),
                intRoot = Math.floor(rRoot),

                lows = range(1, intRoot)
                .filter(x => (n % x) === 0);

            // for perfect squares, we can drop
            // the head of the 'highs' list
            return lows.concat(lows
                .map(x => n / x)
                .reverse()
                .slice((rRoot === intRoot) | 0)
            );
        },

        // range :: Int -> Int -> [Int]
        range = (m, n) => Array.from({
            length: (n - m) + 1
        }, (_, i) => m + i);





    /*************************** TESTING *****************************/

    // TABULATION OF RESULTS IN SPACED AND ALIGNED COLUMNS
    let alignedTable = (lstRows, lngPad, fnAligned) => {
            var lstColWidths = range(
                    0, lstRows
                    .reduce(
                        (a, x) => (x.length > a ? x.length : a),
                        0
                    ) - 1
                )
                .map((iCol) => lstRows
                    .reduce((a, lst) => {
                        let w = lst[iCol] ? lst[iCol].toString()
                            .length : 0;
                        return (w > a) ? w : a;
                    }, 0));

            return lstRows.map((lstRow) =>
                    lstRow.map((v, i) => fnAligned(
                        v, lstColWidths[i] + lngPad
                    ))
                    .join('')
                )
                .join('\n');
        },

        alignRight = (n, lngWidth) => {
            let s = n.toString();
            return Array(lngWidth - s.length + 1)
                .join(' ') + s;
        };

    // TEST
    return '\nintegerFactors(n)\n\n' + alignedTable(lstTest
        .map(integerFactors)
        .map(
            (x, i) => [lstTest[i], '-->'].concat(x)
        ), 2, alignRight
    ) + '\n';

})([25, 45, 53, 64, 100, 102, 120, 12345, 32766, 32767]);

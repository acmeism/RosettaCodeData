(function (n) {
    'use strict';

    // A Pascal triangle of n rows

    // pascal :: Int -> [[Int]]
    function pascal(n) {
        return range(1, n - 1)
            .reduce(function (a) {
                var lstPreviousRow = a.slice(-1)[0];

                return a
                    .concat(
                        [zipWith(
                            function (a, b) {
                                return a + b
                            },
                            [0].concat(lstPreviousRow),
                            lstPreviousRow.concat(0)
                        )]
                    );
            }, [[1]]);
    }



    // GENERIC FUNCTIONS

    // zipWith :: (a -> b -> c) -> [a] -> [b] -> [c]
    function zipWith(f, xs, ys) {
        return xs.length === ys.length ? (
            xs.map(function (x, i) {
                return f(x, ys[i]);
            })
        ) : undefined;
    }

    // range :: Int -> Int -> [Int]
    function range(m, n) {
        return Array.apply(null, Array(n - m + 1))
            .map(function (x, i) {
                return m + i;
            });
    }

    // TEST
    var lstTriangle = pascal(n);


    // FORMAT OUTPUT AS WIKI TABLE

    // [[a]] -> bool -> s -> s
    function wikiTable(lstRows, blnHeaderRow, strStyle) {
        return '{| class="wikitable" ' + (
                strStyle ? 'style="' + strStyle + '"' : ''
            ) + lstRows.map(function (lstRow, iRow) {
                var strDelim = ((blnHeaderRow && !iRow) ? '!' : '|');

                return '\n|-\n' + strDelim + ' ' + lstRow.map(function (
                        v) {
                        return typeof v === 'undefined' ? ' ' : v;
                    })
                    .join(' ' + strDelim + strDelim + ' ');
            })
            .join('') + '\n|}';
    }

    var lstLastLine = lstTriangle.slice(-1)[0],
        lngBase = (lstLastLine.length * 2) - 1,
        nWidth = lstLastLine.reduce(function (a, x) {
            var d = x.toString()
                .length;
            return d > a ? d : a;
        }, 1) * lngBase;

    return [
    wikiTable(
            lstTriangle.map(function (lst) {
                return lst.join(';;')
                    .split(';');
            })
            .map(function (line, i) {
                var lstPad = Array((lngBase - line.length) / 2);
                return lstPad.concat(line)
                    .concat(lstPad);
            }),
            false,
            'text-align:center;width:' + nWidth + 'em;height:' + nWidth +
            'em;table-layout:fixed;'
    ),

    JSON.stringify(lstTriangle)
  ].join('\n\n');
})(7);

(function (n) {
    'use strict';

    // PASCAL TRIANGLE --------------------------------------------------------

    // pascal :: Int -> [[Int]]
    function pascal(n) {
        return foldl(function (a) {
            var xs = a.slice(-1)[0]; // Previous row
            return append(a, [zipWith(
                function (a, b) {
                    return a + b;
                },
                append([0], xs),
                append(xs, [0])
            )]);
        }, [
            [1] // Initial seed row
        ], enumFromTo(1, n - 1));
    };


    // GENERIC FUNCTIONS ------------------------------------------------------

    // (++) :: [a] -> [a] -> [a]
    function append(xs, ys) {
        return xs.concat(ys);
    };

    // enumFromTo :: Int -> Int -> [Int]
    function enumFromTo(m, n) {
        return Array.from({
            length: Math.floor(n - m) + 1
        }, function (_, i) {
            return m + i;
        });
    };

    // foldl :: (b -> a -> b) -> b -> [a] -> b
    function foldl(f, a, xs) {
        return xs.reduce(f, a);
    };

    // foldr (a -> b -> b) -> b -> [a] -> b
    function foldr(f, a, xs) {
        return xs.reduceRight(f, a);
    };

    // map :: (a -> b) -> [a] -> [b]
    function map(f, xs) {
        return xs.map(f);
    };

    // min :: Ord a => a -> a -> a
    function min(a, b) {
        return b < a ? b : a;
    };

    // zipWith :: (a -> b -> c) -> [a] -> [b] -> [c]
    function zipWith(f, xs, ys) {
        return Array.from({
            length: min(xs.length, ys.length)
        }, function (_, i) {
            return f(xs[i], ys[i]);
        });
    };

    // TEST and FORMAT --------------------------------------------------------
    var lstTriangle = pascal(n);

    // [[a]] -> bool -> s -> s
    function wikiTable(lstRows, blnHeaderRow, strStyle) {
        return '{| class="wikitable" ' + (strStyle ? 'style="' + strStyle +
                '"' : '') + lstRows.map(function (lstRow, iRow) {
                var strDelim = blnHeaderRow && !iRow ? '!' : '|';
                return '\n|-\n' + strDelim + ' ' + lstRow.map(function (v) {
                        return typeof v === 'undefined' ? ' ' : v;
                    })
                    .join(' ' + strDelim + strDelim + ' ');
            })
            .join('') + '\n|}';
    }

    var lstLastLine = lstTriangle.slice(-1)[0],
        lngBase = lstLastLine.length * 2 - 1,
        nWidth = lstLastLine.reduce(function (a, x) {
            var d = x.toString()
                .length;
            return d > a ? d : a;
        }, 1) * lngBase;

    return [wikiTable(lstTriangle.map(function (lst) {
            return lst.join(';;')
                .split(';');
        })
        .map(function (line, i) {
            var lstPad = Array((lngBase - line.length) / 2);
            return lstPad.concat(line)
                .concat(lstPad);
        }), false, 'text-align:center;width:' + nWidth + 'em;height:' + nWidth +
        'em;table-layout:fixed;'), JSON.stringify(lstTriangle)].join('\n\n');
})(7);
